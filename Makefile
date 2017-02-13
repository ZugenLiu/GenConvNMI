#------------------------------------------------------------------------------#
# This makefile was generated by 'cbp2make' tool rev.147                       #
#------------------------------------------------------------------------------#


WORKDIR = `pwd`

CC = gcc
CXX = g++
AR = ar
LD = g++
WINDRES = windres

INC = -Iinclude -Ishared
CFLAGS = -Wnon-virtual-dtor -Wredundant-decls -Wcast-align -Wundef -Wunreachable-code -Wmissing-include-dirs -Weffc++ -Wzero-as-null-pointer-constant -std=c++14 -fexceptions
RESINC = 
LIBDIR = 
LIB = -lboost_program_options -ltbb -lpthread
LDFLAGS = 

INC_DEBUG = $(INC)
CFLAGS_DEBUG = $(CFLAGS) -Winit-self -Wfloat-equal -Winline -Wall -g -DDEBUG
RESINC_DEBUG = $(RESINC)
RCFLAGS_DEBUG = $(RCFLAGS)
LIBDIR_DEBUG = $(LIBDIR)
LIB_DEBUG = $(LIB)
LDFLAGS_DEBUG = $(LDFLAGS)
OBJDIR_DEBUG = obj/Debug
DEP_DEBUG = 
OUT_DEBUG = bin/Debug/gecmi

INC_RELEASE = $(INC)
CFLAGS_RELEASE = $(CFLAGS) -march=core2 -fomit-frame-pointer -O3 -Wfatal-errors
RESINC_RELEASE = $(RESINC)
RCFLAGS_RELEASE = $(RCFLAGS)
LIBDIR_RELEASE = $(LIBDIR)
LIB_RELEASE = $(LIB)
LDFLAGS_RELEASE = $(LDFLAGS) -s
OBJDIR_RELEASE = obj/Release
DEP_RELEASE = 
OUT_RELEASE = bin/Release/gecmi

INC_PROFILE = $(INC)
CFLAGS_PROFILE = $(CFLAGS) -march=core2 -O3 -Wfatal-errors -pg
RESINC_PROFILE = $(RESINC)
RCFLAGS_PROFILE = $(RCFLAGS)
LIBDIR_PROFILE = $(LIBDIR)
LIB_PROFILE = $(LIB)
LDFLAGS_PROFILE = $(LDFLAGS) -pg
OBJDIR_PROFILE = obj/Profile
DEP_PROFILE = 
OUT_PROFILE = bin/Profile/gecmi

OBJ_DEBUG = $(OBJDIR_DEBUG)/src/representants.o $(OBJDIR_DEBUG)/src/player_automaton.o $(OBJDIR_DEBUG)/src/deep_complete_simulator.o $(OBJDIR_DEBUG)/src/confusion.o $(OBJDIR_DEBUG)/src/cluster_reader.o $(OBJDIR_DEBUG)/src/calculate_till_tolerance.o $(OBJDIR_DEBUG)/gecmi.o

OBJ_RELEASE = $(OBJDIR_RELEASE)/src/representants.o $(OBJDIR_RELEASE)/src/player_automaton.o $(OBJDIR_RELEASE)/src/deep_complete_simulator.o $(OBJDIR_RELEASE)/src/confusion.o $(OBJDIR_RELEASE)/src/cluster_reader.o $(OBJDIR_RELEASE)/src/calculate_till_tolerance.o $(OBJDIR_RELEASE)/gecmi.o

OBJ_PROFILE = $(OBJDIR_PROFILE)/src/representants.o $(OBJDIR_PROFILE)/src/player_automaton.o $(OBJDIR_PROFILE)/src/deep_complete_simulator.o $(OBJDIR_PROFILE)/src/confusion.o $(OBJDIR_PROFILE)/src/cluster_reader.o $(OBJDIR_PROFILE)/src/calculate_till_tolerance.o $(OBJDIR_PROFILE)/gecmi.o

all: debug release profile

clean: clean_debug clean_release clean_profile

before_debug: 
	test -d bin/Debug || mkdir -p bin/Debug
	test -d $(OBJDIR_DEBUG)/src || mkdir -p $(OBJDIR_DEBUG)/src
	test -d $(OBJDIR_DEBUG) || mkdir -p $(OBJDIR_DEBUG)

after_debug: 

debug: before_debug out_debug after_debug

out_debug: before_debug $(OBJ_DEBUG) $(DEP_DEBUG)
	$(LD) $(LIBDIR_DEBUG) -o $(OUT_DEBUG) $(OBJ_DEBUG)  $(LDFLAGS_DEBUG) $(LIB_DEBUG)

$(OBJDIR_DEBUG)/src/representants.o: src/representants.cpp
	$(CXX) $(CFLAGS_DEBUG) $(INC_DEBUG) -c src/representants.cpp -o $(OBJDIR_DEBUG)/src/representants.o

$(OBJDIR_DEBUG)/src/player_automaton.o: src/player_automaton.cpp
	$(CXX) $(CFLAGS_DEBUG) $(INC_DEBUG) -c src/player_automaton.cpp -o $(OBJDIR_DEBUG)/src/player_automaton.o

$(OBJDIR_DEBUG)/src/deep_complete_simulator.o: src/deep_complete_simulator.cpp
	$(CXX) $(CFLAGS_DEBUG) $(INC_DEBUG) -c src/deep_complete_simulator.cpp -o $(OBJDIR_DEBUG)/src/deep_complete_simulator.o

$(OBJDIR_DEBUG)/src/confusion.o: src/confusion.cpp
	$(CXX) $(CFLAGS_DEBUG) $(INC_DEBUG) -c src/confusion.cpp -o $(OBJDIR_DEBUG)/src/confusion.o

$(OBJDIR_DEBUG)/src/cluster_reader.o: src/cluster_reader.cpp
	$(CXX) $(CFLAGS_DEBUG) $(INC_DEBUG) -c src/cluster_reader.cpp -o $(OBJDIR_DEBUG)/src/cluster_reader.o

$(OBJDIR_DEBUG)/src/calculate_till_tolerance.o: src/calculate_till_tolerance.cpp
	$(CXX) $(CFLAGS_DEBUG) $(INC_DEBUG) -c src/calculate_till_tolerance.cpp -o $(OBJDIR_DEBUG)/src/calculate_till_tolerance.o

$(OBJDIR_DEBUG)/gecmi.o: gecmi.cpp
	$(CXX) $(CFLAGS_DEBUG) $(INC_DEBUG) -c gecmi.cpp -o $(OBJDIR_DEBUG)/gecmi.o

clean_debug: 
	rm -f $(OBJ_DEBUG) $(OUT_DEBUG)
	rm -rf bin/Debug
	rm -rf $(OBJDIR_DEBUG)/src
	rm -rf $(OBJDIR_DEBUG)

before_release: 
	test -d bin/Release || mkdir -p bin/Release
	test -d $(OBJDIR_RELEASE)/src || mkdir -p $(OBJDIR_RELEASE)/src
	test -d $(OBJDIR_RELEASE) || mkdir -p $(OBJDIR_RELEASE)

after_release: 

release: before_release out_release after_release

out_release: before_release $(OBJ_RELEASE) $(DEP_RELEASE)
	$(LD) $(LIBDIR_RELEASE) -o $(OUT_RELEASE) $(OBJ_RELEASE)  $(LDFLAGS_RELEASE) $(LIB_RELEASE)

$(OBJDIR_RELEASE)/src/representants.o: src/representants.cpp
	$(CXX) $(CFLAGS_RELEASE) $(INC_RELEASE) -c src/representants.cpp -o $(OBJDIR_RELEASE)/src/representants.o

$(OBJDIR_RELEASE)/src/player_automaton.o: src/player_automaton.cpp
	$(CXX) $(CFLAGS_RELEASE) $(INC_RELEASE) -c src/player_automaton.cpp -o $(OBJDIR_RELEASE)/src/player_automaton.o

$(OBJDIR_RELEASE)/src/deep_complete_simulator.o: src/deep_complete_simulator.cpp
	$(CXX) $(CFLAGS_RELEASE) $(INC_RELEASE) -c src/deep_complete_simulator.cpp -o $(OBJDIR_RELEASE)/src/deep_complete_simulator.o

$(OBJDIR_RELEASE)/src/confusion.o: src/confusion.cpp
	$(CXX) $(CFLAGS_RELEASE) $(INC_RELEASE) -c src/confusion.cpp -o $(OBJDIR_RELEASE)/src/confusion.o

$(OBJDIR_RELEASE)/src/cluster_reader.o: src/cluster_reader.cpp
	$(CXX) $(CFLAGS_RELEASE) $(INC_RELEASE) -c src/cluster_reader.cpp -o $(OBJDIR_RELEASE)/src/cluster_reader.o

$(OBJDIR_RELEASE)/src/calculate_till_tolerance.o: src/calculate_till_tolerance.cpp
	$(CXX) $(CFLAGS_RELEASE) $(INC_RELEASE) -c src/calculate_till_tolerance.cpp -o $(OBJDIR_RELEASE)/src/calculate_till_tolerance.o

$(OBJDIR_RELEASE)/gecmi.o: gecmi.cpp
	$(CXX) $(CFLAGS_RELEASE) $(INC_RELEASE) -c gecmi.cpp -o $(OBJDIR_RELEASE)/gecmi.o

clean_release: 
	rm -f $(OBJ_RELEASE) $(OUT_RELEASE)
	rm -rf bin/Release
	rm -rf $(OBJDIR_RELEASE)/src
	rm -rf $(OBJDIR_RELEASE)

before_profile: 
	test -d bin/Profile || mkdir -p bin/Profile
	test -d $(OBJDIR_PROFILE)/src || mkdir -p $(OBJDIR_PROFILE)/src
	test -d $(OBJDIR_PROFILE) || mkdir -p $(OBJDIR_PROFILE)

after_profile: 

profile: before_profile out_profile after_profile

out_profile: before_profile $(OBJ_PROFILE) $(DEP_PROFILE)
	$(LD) $(LIBDIR_PROFILE) -o $(OUT_PROFILE) $(OBJ_PROFILE)  $(LDFLAGS_PROFILE) $(LIB_PROFILE)

$(OBJDIR_PROFILE)/src/representants.o: src/representants.cpp
	$(CXX) $(CFLAGS_PROFILE) $(INC_PROFILE) -c src/representants.cpp -o $(OBJDIR_PROFILE)/src/representants.o

$(OBJDIR_PROFILE)/src/player_automaton.o: src/player_automaton.cpp
	$(CXX) $(CFLAGS_PROFILE) $(INC_PROFILE) -c src/player_automaton.cpp -o $(OBJDIR_PROFILE)/src/player_automaton.o

$(OBJDIR_PROFILE)/src/deep_complete_simulator.o: src/deep_complete_simulator.cpp
	$(CXX) $(CFLAGS_PROFILE) $(INC_PROFILE) -c src/deep_complete_simulator.cpp -o $(OBJDIR_PROFILE)/src/deep_complete_simulator.o

$(OBJDIR_PROFILE)/src/confusion.o: src/confusion.cpp
	$(CXX) $(CFLAGS_PROFILE) $(INC_PROFILE) -c src/confusion.cpp -o $(OBJDIR_PROFILE)/src/confusion.o

$(OBJDIR_PROFILE)/src/cluster_reader.o: src/cluster_reader.cpp
	$(CXX) $(CFLAGS_PROFILE) $(INC_PROFILE) -c src/cluster_reader.cpp -o $(OBJDIR_PROFILE)/src/cluster_reader.o

$(OBJDIR_PROFILE)/src/calculate_till_tolerance.o: src/calculate_till_tolerance.cpp
	$(CXX) $(CFLAGS_PROFILE) $(INC_PROFILE) -c src/calculate_till_tolerance.cpp -o $(OBJDIR_PROFILE)/src/calculate_till_tolerance.o

$(OBJDIR_PROFILE)/gecmi.o: gecmi.cpp
	$(CXX) $(CFLAGS_PROFILE) $(INC_PROFILE) -c gecmi.cpp -o $(OBJDIR_PROFILE)/gecmi.o

clean_profile: 
	rm -f $(OBJ_PROFILE) $(OUT_PROFILE)
	rm -rf bin/Profile
	rm -rf $(OBJDIR_PROFILE)/src
	rm -rf $(OBJDIR_PROFILE)

.PHONY: before_debug after_debug clean_debug before_release after_release clean_release before_profile after_profile clean_profile

