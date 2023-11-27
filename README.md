# Part 1 Key Points Detection

## General Project Submission Info

https://gist.github.com/tddschn/7c81e97b3aa088a999cb1d06639d222c

## Overview
This README outlines the steps to compile and build the LLVM pass for branch and pointer profiling on UNIX systems.

Learn more [here](./objective.md).

<!-- Teddy Xinyuan Chen's dev branch: [teddy-dev](https://github.com/ncsu-csc512-project/part1-dev/tree/teddy-dev) -->

## Prerequisites
- LLVM >= 16.0 installed
- CMake installed
- C++ compiler (e.g., g++, clang)




## Build the Pass

Clone the repo first if you haven't already:
```bash
git clone https://github.com/ncsu-csc512-project/part1-dev.git
```

Navigate to the root directory of the repo and run the following commands to build the pass:

```bash
# export LLVM_DIR=/usr/local/Cellar/llvm/17.0.2 # replace with your LLVM installation directory
# 
# mkdir build
# 
# # builds ./build/BranchPointerPass/libBranchPointerPass.so
# cmake -DMY_LLVM_INSTALL_DIR=$LLVM_DIR -S . -B build && cmake --build build
make build
# you can specify the LLVM installation directory and clang and opt commands as follows:
# make LLVM_DIR=/usr/lib/llvm-17 CLANG_COMMAND=/usr/bin/clang-17 OPT_COMMAND=/usr/bin/opt-17 build
```

## Running the Pass
After building, you should have a `libBranchPointerPass.so` file in your `build` directory. To run the pass, use LLVM's `opt` tool as follows:
```bash
# opt -load-pass-plugin ./build/BranchPointerPass/libBranchPointerPass.so -passes=branch-pointer-pass -disable-output inputs/input.ll
make
# you can specify the LLVM installation directory and clang and opt commands as follows:
# make LLVM_DIR=/usr/lib/llvm-17 CLANG_COMMAND=/usr/bin/clang-17 OPT_COMMAND=/usr/bin/opt-17
```

Replace `input.ll` with the LLVM IR file you want to analyze.

## Output

```
$ make

export LLVM_DIR=/usr/local/opt/llvm
mkdir -p build
cmake -DMY_LLVM_INSTALL_DIR=/usr/local/opt/llvm -S . -B build && cmake --build build
-- Configuring done (0.4s)
-- Generating done (0.1s)
-- Build files have been written to: /Users/tscp/testdir/csc512-proj/part1-dev/build
gmake[1]: Entering directory '/Users/tscp/testdir/csc512-proj/part1-dev/build'
[ 50%] Building CXX object BranchPointerPass/CMakeFiles/BranchPointerPass.dir/BranchPointerPass.cpp.o
[100%] Linking CXX shared module libBranchPointerPass.so
[100%] Built target BranchPointerPass
gmake[1]: Leaving directory '/Users/tscp/testdir/csc512-proj/part1-dev/build'
opt -load-pass-plugin ./build/BranchPointerPass/libBranchPointerPass.so -passes=branch-pointer-pass -disable-output inputs/input.ll
br_1: inputs/input.c, 19, 21
br_2: inputs/input.c, 21, 23
# opt -load-pass-plugin ./build/BranchPointerTracePass/libBranchPointerTracePass.so -passes=branch-pointer-trace -disable-output inputs/input.ll
# opt -load-pass-plugin ./build/BranchPointerTracePass/libBranchPointerTracePass.so -passes=branch-pointer-trace -disable-output inputs/input.ll
```

`dict.json` file generated when running the pass for storing the branching info:

```json
[
    {
        "branch_id": 1,
        "dest_lno": 21,
        "filename": "inputs/input.c",
        "src_lno": 19
    },
    {
        "branch_id": 2,
        "dest_lno": 23,
        "filename": "inputs/input.c",
        "src_lno": 21
    }
]
```