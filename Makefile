# -------------------------------------- #
# Main Makefile
#
# @author	Christian H. Bohlbro
# @date		2018.09.17
# @version	0.8
# -------------------------------------- #

# Making for release (default)
# > make
CXXFLAGS		=-O2 -I./src
MODE			=release

# Making for debugging
# > make DEBUG=1
ifdef DEBUG
CXXFLAGS		=-ggdb3 -I./src
MODE			=debug
endif

# -------------------------------------- #
# Variables
# -------------------------------------- #
# Executables
EXE				=main
GTEST_EXE		=gtest

# Paths
SRC_PATH		=src
BUILD_PATH		=build/$(MODE)
BIN_PATH		=bin/$(MODE)

# Files
SOURCES			=$(shell find $(SRC_PATH) -name '*.cpp' | sort -k 1nr | cut -f2-)
OBJECTS			=$(SOURCES:$(SRC_PATH)/%.cpp=$(BUILD_PATH)/%.o)
DEPS			=$(OBJECTS:%.o=%.d)
CXX				=g++
CXXFLAGS		+= -std=c++1z -Wall
LDFLAGS			=-lpthread

# GoogleTest variables
GTEST_PATH		=test
GTEST_LDFLAGS	=-lgtest -lpthread
GTEST_SOURCES 	=gtest_main.cpp TemplateUnitTest.cpp
GTEST_OBJECTS	=$(addprefix $(BUILD_PATH)/, $(GTEST_SOURCES:.cpp=.o))
GTEST_DEPS		=$(GTEST_OBJECTS:.o=.d)

# -------------------------------------- #
# Misc
# -------------------------------------- #

# Prevents potential invalid targets
.PHONY: all clean run gtest

# Default target
all: info ${BIN_PATH}/${EXE}

# Display compilation info
info:
	@ echo "Compiling for '${BIN_PATH}/${EXE}' in '${MODE}' mode..."

# -------------------------------------- #
# Dependencies
# -------------------------------------- #
# Create dependencies with the proper prerequisites.
${BUILD_PATH}/%.d: $(BUILD_PATH) $(SRC_PATH)/%.cpp
	@ echo "Compiling dependency file '$@' using '"$^"'"
	@ $(CXX) -MT$(@:.d=.o) -MM $(CXXFLAGS) $(filter-out $<,$^) > $@

${BUILD_PATH}/%.d: $(BUILD_PATH) $(GTEST_PATH)/%.cpp
	@ echo "Compiling test dependency file '$@' using '"$^"'"
	@ $(CXX) -MT$(@:.d=.o) -MM $(CXXFLAGS) $(filter-out $<,$^) > $@

# Include all dependencies
ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS) $(GTEST_DEPS)
endif

# -------------------------------------- #
# Objects
# -------------------------------------- #
# Compile all object files from the included dependencies
${BUILD_PATH}/%.o: $(SRC_PATH)/%.cpp
	@ echo "Compiling object file $@ using '"$<"'"
	@ ${CXX} -c -o $@ $< ${CXXFLAGS}

# Compile all object files for gtest from the inlcuded dependencies
${BUILD_PATH}/%.o: $(GTEST_PATH)/%.cpp
	@ echo "Compiling test object file '$@' using '"$<"'"
	@ ${CXX} -c -o $@ $< ${CXXFLAGS}

# -------------------------------------- #
# Folders
# -------------------------------------- #
${BIN_PATH}:
	@ mkdir -p $(BIN_PATH)

${BUILD_PATH}:
	@ mkdir -p $(BUILD_PATH)

# -------------------------------------- #
# Makefile runnables
# -------------------------------------- #
# Linking main executable
${BIN_PATH}/${EXE}: $(BIN_PATH) $(DEPS) $(OBJECTS)
	@ echo "Linking '${BIN_PATH}/${EXE}'"
	@ ${CXX} -o $@ $(OBJECTS) $(LDFLAGS)

# Linking gtest executable
${BIN_PATH}/${GTEST_EXE}: $(BIN_PATH) $(GTEST_DEPS) $(GTEST_OBJECTS)
	@ echo "Linking '${BIN_PATH}/${GTEST_EXE}'"
	@ ${CXX} -o $@ ${GTEST_OBJECTS} ${GTEST_LDFLAGS}
	@ echo "Running GoogleTest on '${BIN_PATH}/${GTEST_EXE}'"
	@ ./${BIN_PATH}/${GTEST_EXE}

# Clean all object files and the main target
clean:
	@ echo "Cleaning up files..."
	@ rm -f  $(EXE)
	@ rm -f  $(GTEST_EXE)
	@ rm -rf $(BUILD_PATH)
	@ rm -rf $(BIN_PATH)

# Runs the main target executable
run:
	@ ./${BIN_PATH}/${EXE}

# Compiles the test files with the required .hpp and .cpp files.
gtest: ${BIN_PATH}/${GTEST_EXE}
