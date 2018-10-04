# c++ Template

## Introduction

This project is mostly for personal use. It's a basic template for compiling and running basic c/c++ code. It also has a basic GoogleTest integration. This feature allows the user to add UnitTest files to the test repository and by including them in the Makefile, they will be compiled and run, providing the test feedback into the console. See below for further usage.

## Prerequisites

### GoogleTest
For this to work, GoogleTest must be installed to `/usr/local/include` on OSX or where ever it can be installed on other OS.

#### Installing Google Test on OSX
The following will show how to install the GoogleTest library onto your OS X system. This has been tested with GoogleTest version `1.8.1`. Feel free to use the latest version, but I cannot guarantee that this installation guide will work then.

First some system details:

- **OS**: macOS Mojave, OS X 10.14

I'd recommend installing it in your home `~/`, since it will be easier to find and navigate to from the terminal. It will also be easy to delete in the future.

To download GoogleTest, use the following command.

```sh
$ curl -fsSL https://github.com/google/googletest/archive/release-1.8.1.tar.gz -o /tmp/release-1.8.1.tar.gz
```

This will download GoogleTest version `1.8.1` which I will be using, into `~/tmp/release-1.8.1.tar.gz`.

Next, unpack the file and create a `build/` directory using:

```sh
$ tar -xzf /tmp/release-1.8.1.tar.gz
$ mkdir -p /tmp/googletest-release-1.8.1/build
```

After that, we can `make` the repository using `cmake`. If you don't have `cmake`, you can install it with homebrew. But first we must cd into the build directory, then we can run `cmake` with some flags.

```sh
$ cd /tmp/googletest-release-1.8.1/build
$ cmake -DCMAKE_CXX_COMPILER="c++" -DCMAKE_CXX_FLAGS="-std=c++11 -stdlib=libc++" ../
```

Now we can `make` the repository using:

```
$ make
```

This will create a `googlemock` repository, which we can use to install GoogleTest into our system:

```sh
$ cd googlemock/gtest
```

Copy all library files into `/usr/local/lib` using:

```sh
$ cp lib*.a /usr/local/lib
```

-Some text that needs to be edited here-

```sh
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
