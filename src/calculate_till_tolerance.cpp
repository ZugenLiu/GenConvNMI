#include <tbb/task_scheduler_init.h> // <-- For controlling number of working threads
#include <tbb/parallel_for.h>

#include "bimap_cluster_populator.hpp"
#include "confusion.hpp"
#include "parallel_worker.hpp"
#include "deep_complete_simulator.hpp"
#include "calculate_till_tolerance.hpp"


//constexpr size_t  EVCOUNT_THRESHOLD = 8192;  // Gives also good results on middle-size networks
// Grain: 1024 .. 2048;  1536 is ~ the best on both middle-size and large networks
// on the working laptop (4 cores Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz-3.3 GHz)
// Checked in the range 128 .. 8192
// Note: it has not significant dependence on the taks complexity: the same value is
// optimal using vector instantiation and shuffling
constexpr size_t  EVCOUNT_GRAIN = 1536;

namespace gecmi {

using std::domain_error;
using std::to_string;

calculated_info_t calculate_till_tolerance(
    two_relations_ref two_rel,
    double risk , // <-- Upper bound of probability of the true value being
                  //  -- farthest from estimated value than the epvar
    double epvar,
    bool fasteval,  // Use more approximate, but faster evaluation
    size_t nds1num, size_t nds2num  // The number of nodes in the collections (if specified, otherwise 0)
    )
{
    assert(risk > 0 && risk < 1 && epvar > 0 && epvar < 1 && "risk and epvar should E (0, 1)");

    importance_matrix_t norm_conf;
    importance_vector_t norm_cols;
    importance_vector_t norm_rows;

    // left: Nodes, right: Clusters
    size_t rows = uniqSize(two_rel.first.right) + 1;
    size_t cols = uniqSize(two_rel.second.right) + 1;

    counter_matrix_t cm =
        boost::numeric::ublas::zero_matrix< importance_float_t >( rows, cols );

    importance_float_t nmi;
    importance_float_t max_var = 1.0e10;

    vertices_t  vertices;
    vertices.reserve( nds1num ? nds1num : uniqSize( two_rel.first.left ) );
    {
        bool  basefirst = true;  // Use first collection as vertices base
//#ifdef DEBUG
        const auto  verts2Size = nds2num ? nds2num : uniqSize( two_rel.second.left );
        if(vertices.capacity() != verts2Size) {
            fprintf(stderr, "WARNING calculate_till_tolerance(), the number of nodes is different"
                " in the comparing collections: %lu != %lu\n", vertices.capacity(), verts2Size);
            //throw domain_error("calculate_till_tolerance(), The vertices of both clusterings should be the same: "
            //    + to_string(vertices.size()) + " != " + to_string(vertDbgSize) + "\n");
            //
            // If the node base is not synced between the collections then use the smallest node base,
            // because the missed vertices contribute nothing to NMI
            if(vertices.capacity() > verts2Size) {
                vertices.reserve(verts2Size);
                basefirst = false;
            }
        }
//#endif  // DEBUG
        auto& vmap = basefirst ? two_rel.first.left : two_rel.second.left;  // First vmap
        // Fill the vertices
        for(const auto& ind = vmap.begin(); ind != vmap.end();) {
            vertices.push_back(ind->first);
            const_cast<typename std::remove_reference_t<decltype(vmap)>::iterator&>(ind)
                = vmap.equal_range(ind->first).second;
        }
    }

    deep_complete_simulator dcs(two_rel, vertices);

    // Evaluate required accuracy:
    const double  acr = 2*risk/(risk + epvar)*epvar;
    // Evaluate required visiting ratio:  node_acr_min >= (1 / (node_degree=2) / 2) ^ visrt
    // Note: /2 because any link has 2 incident nodes and is evaluated from both sides
    // P_lowest(link) occurs in case the node has 2 links and is equal to: (1/node_degree / 2)^visrt
    // => visrt <= log_0.25(node_acr_min) = log_2(node_acr_min)/-2 < log2(acr) / -2
    // Note: log2(acr=0..1) < 0   => log2(acr) / -2 > 0
    // For the whole network the accuracy is much higher

    // The expected number of vertices to process (considering multiple walks through the same vertex)
    //size_t  steps = vertices.size() * 0.65 * log2(acr) / -2;  // Note: *0.65 because anyway visrt is selected too large
    float  avgdeg = fasteval ? 0.825f : 1;  // Normalized average degree [0, 1], let it be 0.65 for 10K and decreasing on larger nets
    // Note: vertices relations (>= vertices) are counted for the steps, which is important
    // in case the collection is a flattened hierarchy with multiple memberships for the nodes ~= number of levels
    const size_t  steps_base = std::min(two_rel.first.left.size(), two_rel.second.left.size());
    if(fasteval) {
        const float  degrt = log2(steps_base) - log2(32768);  // 2^15 = 32768
        if(degrt > 1 / avgdeg)  // ~ >= 60 K
            avgdeg = 1 / degrt;
    }
    size_t  steps = steps_base * avgdeg * log2(acr) / -2;  // Note: *0.65 because anyway visrt is selected too large
//    printf("# calculate_till_tolerance(), steps: %lu, reassigned marg: %G\n"
//        , steps, steps_base * 1.75f * avgdeg);
    if(steps < steps_base * 1.25f * avgdeg) {
        //assert(0 && "The number of steps is expected to be at least twice the number of vertices");
        steps = steps_base * 1.25f * avgdeg;
    }
#ifdef DEBUG
    printf("# calculate_till_tolerance(), vertices: %lu, steps: %lu (%G%%), navgdeg: %G\n"
        , vertices.size(), steps, steps * 100.f / vertices.size(), avgdeg);
#endif  // DEBUG

    // Use this to adjust number of threads
    tbb::task_scheduler_init tsi;

    while( epvar < max_var )
    {
        // For the number of steps randomly selected vertices fill the matrix of modules (clusters) correspondence
        tbb::spin_mutex wait_for_matrix;
        try {
            parallel_for(
                tbb::blocked_range< size_t >( 0, steps, EVCOUNT_GRAIN ),  // EVCOUNT_THRESHOLD
                direct_worker< counter_matrix_t* >( dcs, &cm, &wait_for_matrix )
            );
        } catch (tbb::tbb_exception const& e) {
            throw domain_error("SystemIsSuspiciuslyFailingTooMuch ctt (maybe your partition is not solvable?)\n");
        }

        size_t total_events = total_events_from_unmi_cm( cm );
        normalize_events(
            cm,
            norm_conf,
            norm_cols,
            norm_rows
            );
        variances_at_prob(
            norm_conf, norm_cols, norm_rows,
            total_events,
            risk,
            max_var,
            nmi
            );
#ifdef DEBUG
        fprintf(stderr, "# calculate_till_tolerance(), iteration completed  with %lu events"
            " and max_var: %G (epvar: %G)\n", total_events, max_var, epvar);
#endif  // DEBUG
    }

#ifdef DEBUG
    fprintf(stderr, "# calculate_till_tolerance(), completed  max_var: %G, nmi: %G\n", max_var, nmi);
#endif  // DEBUG
    return calculated_info_t{max_var, nmi};
}// calculate_till_tolerance

}  // gecmi
