# c++ Template

## Introduction

This project is mostly for personal use. It's a basic template for compiling and running basic c/c++ code. It also has a basic GoogleTest integration. This feature allows the user to add UnitTest files to the test repository and by including them in the Makefile, they will be compiled and run, providing the test feedback into the console. See below for further usage.

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

### GoogleTest

To use the googletest integration, the proper files in the test folder must be provided. This often consists of cpp files having the `TEST` functions defined. By including it in the Makefile, the following commands compiles and runs the unittests.

```sh
$ make gtest
```
