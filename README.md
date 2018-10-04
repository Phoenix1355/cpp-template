# c++ Template

## Introduction

This project is mostly for personal use. It's a basic template for compiling and running basic c/c++ code. It also has a basic GoogleTest integration. This feature allows the user to add UnitTest files to the test repository and by including them in the Makefile, they will be compiled and run, providing the test feedback into the console. See below for further usage.

## Prerequisites

For this to work, GoogleTest must be installed to `/usr/local/include` on OSX or where ever it can be installed on other OS.

### Installing Google Test on OSX
**_Cmake_**

Cmake is required to build the Google Test libraries. 
Installing it is easy with homebrew:
```sh
brew install cmake
```

To install Google Test run the following set of shell commands in your prefered terminal. 

```sh
  $ curl -fsSL https://github.com/google/googletest/archive/release-1.8.1.tar.gz -o /tmp/release-1.8.1.tar.gz
  $ tar -xzf /tmp/release-1.8.1.tar.gz
  $ mkdir -p /tmp/googletest-release-1.8.1/build
  $ cd /tmp/googletest-release-1.8.1/build
  $ cmake -DCMAKE_CXX_COMPILER="c++" -DCMAKE_CXX_FLAGS="-std=c++11 -stdlib=libc++" ../ >/dev/null
  $ make -j >/dev/null
  $ cd googlemock/gtest
  $ cp lib*.a /usr/local/lib
  $ cd ../../../googletest
  $ mkdir -p /usr/local/include/gtest
  $ cp -r include/gtest $pwd/$path/include/gtest
```

## Usage

### Main

The main project can be made using the basic make command:

```sh
$ make
```

To enable debugging (ggdb3), use the following:

```sh
$ make DEBUG=1
```

To run the program, use the following:

```sh
$ make run 
```

### GoogleTest

To use the googletest integration, the proper files in the test folder must be provided. This often consists of cpp files having the `TEST` functions defined. By including it in the Makefile, the following commands compiles and runs the unittests.

```sh
$ make gtest
```
