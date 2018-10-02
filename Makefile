# -------------------------------------- #
# Main Makefile
#
# @author	Christian H. Bohlbro
# @date		2018.09.17
# @version	0.8
# -------------------------------------- #

# -------------------------------------- #
# Variables
# -------------------------------------- #

# Paths
SRC_PATH		=src
BUILD_PATH		=build
BIN_PATH		=$(BUILD_PATH)/bin
OBJ_PATH		=$(BUILD_PATH)/obj

# Executables
TARGET			=$(BIN_PATH)/PROG

# Files
SOURCES			=$(shell find $(SRC_PATH) -name '*.cpp' | sort -k 1nr | cut -f2-)
OBJECTS			=$(SOURCES:$(SRC_PATH)/%.cpp=$(OBJ_PATH)/%.o)
DEPS			=$(OBJECTS:%.o=%.d)
CXX				=g++
CXXFLAGS		=-ggdb -I. -I./src -std=c++1z -stdlib=libc++

# GoogleTest variables
GTEST_DIR		=test
GTEST_TARGET	=$(BIN_PATH)/GTEST
GTEST_FLAGS		=-g -lgtest -lpthread
GTEST_SOURCES 	=
GTEST_UNITS		=gtest_main.cpp HeapUnitTest.cpp
GTEST_OBJFILES	=$(GTEST_SOURCES:.cpp=.o) $(GTEST_UNITS:.cpp=.o)
GTEST_OBJECTS	=$(addprefix $(OBJ_PATH)/, $(GTEST_OBJFILES))
GTEST_DEPS		=$(GTEST_OBJECTS:.o=.d)

# -------------------------------------- #
# Misc
# -------------------------------------- #

# Prevents potential invalid targets
.PHONY: all clean run gtest

# Default target
all: ${TARGET}

# -------------------------------------- #
# Dependencies
# -------------------------------------- #

# Create dependencies with the proper prerequisites.
$(OBJ_PATH)/%.d: $(SRC_PATH)/%.cpp
	@ echo Compiling dependency file $@ using $^
	@ mkdir -p $(OBJ_PATH)
	@ $(CXX) -MT$(@:.d=.o) -MM $(CXXFLAGS) $^ > $@

$(OBJ_PATH)/%.d: $(GTEST_DIR)/%.cpp
	@ echo Compiling test dependency file $@ using $^
	@ mkdir -p $(OBJ_PATH)
	@ $(CXX) -MT$(@:.d=.o) -MM $(CXXFLAGS) $^ > $@

# Include all dependencies
-include $(DEPS) $(GTEST_DEPS)

# -------------------------------------- #
# Objects
# -------------------------------------- #

# Compile all object files from the imported dependencies
$(OBJ_PATH)/%.o: $(SRC_PATH)/%.cpp
	@ echo Compiling test object file $@ using $<
	@ ${CXX} -c -o $@ $< ${CXXFLAGS}

$(OBJ_PATH)/%.o: $(GTEST_DIR)/%.cpp
	@ echo Compiling test object file $@ using $<
	@ ${CXX} -c -o $@ $< ${CXXFLAGS}

# -------------------------------------- #
# Makefile runnables
# -------------------------------------- #

# Linking main executable
${TARGET}: $(DEPS) $(OBJECTS)
	@ echo Linking ${TARGET}
	@ mkdir -p $(BIN_PATH)
	@ ${CXX} -o $@ $(OBJECTS)

# Clean all object files and the main target
clean:
	@ echo Cleaning ${TARGET}
	@ rm -f  $(TARGET)
	@ rm -f  $(GTEST_TARGET)
	@ rm -rf $(BUILD_PATH)

# Runs the main target executable
run:
	@ ./${TARGET}

# Compiles the test files with the required .hpp and .cpp files.
gtest: $(GTEST_DEPS) $(GTEST_OBJECTS)
	@ echo Linking ${GTEST_TARGET}
	@ mkdir -p $(BIN_PATH)
	@ ${CXX} -o $(GTEST_TARGET) ${GTEST_OBJECTS} ${GTEST_FLAGS}
	@ echo Running GoogleTest on $(GTEST_TARGET)
	@ ./${GTEST_TARGET}
