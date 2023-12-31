# Part 1 Key Points Detection LLVM Pass & Valgrind Instruction Count Tool

- [Part 1 Key Points Detection LLVM Pass \& Valgrind Instruction Count Tool](#part-1-key-points-detection-llvm-pass--valgrind-instruction-count-tool)
  - [General Project Submission Info](#general-project-submission-info)
    - [Project Submission](#project-submission)
    - [GitHub Links](#github-links)
  - [Overview](#overview)
  - [Project Structure](#project-structure)
  - [Prerequisites](#prerequisites)
    - [3rd party libraries](#3rd-party-libraries)
  - [Build the Pass](#build-the-pass)
  - [Running the Pass](#running-the-pass)
  - [Output](#output)
  - [Technical Details](#technical-details)
    - [optimization flags](#optimization-flags)
  - [Test C programs](#test-c-programs)
  - [Valgrind instruction count](#valgrind-instruction-count)
    - [Building](#building)
    - [Usage](#usage)
    - [Output](#output-1)

## General Project Submission Info

<!-- https://gist.github.com/tddschn/7c81e97b3aa088a999cb1d06639d222c -->

<details>
<summary>Click to expand</summary>

### Project Submission 

Authors:

- Teddy Xinyuan Chen (xchen87, [github.com/tddschn](https://github.com/tddschn)) - Part 1 & 3
- Haojie Zhou (hzhou33) - Part 2


### GitHub Links

<!-- The repositories are all private, please email [xchen87@ncsu.edu](mailto:xchen87@ncsu.edu) to request for access. -->

- [https://github.com/ncsu-csc512-project/part1-dev](https://github.com/ncsu-csc512-project/part1-dev/)
- [https://github.com/ncsu-csc512-project/part1-submission](https://github.com/ncsu-csc512-project/part1-submission)
- [https://github.com/ncsu-csc512-project/part2-dev](https://github.com/ncsu-csc512-project/part2-dev)
- [https://github.com/ncsu-csc512-project/part2-submission](https://github.com/ncsu-csc512-project/part2-submission)
- [https://github.com/ncsu-csc512-project/part3-dev](https://github.com/ncsu-csc512-project/part3-dev)
- [https://github.com/ncsu-csc512-project/part3-submission](https://github.com/ncsu-csc512-project/part3-submission)

<!-- Two important rules:

Make sure you have an empty line after the closing </summary> tag, otherwise the markdown/code blocks won't show correctly.
Make sure you have an empty line after the closing </details> tag if you have multiple collapsible sections. -->
</details>

## Overview
This README outlines the steps to compile and build the LLVM pass for branch and pointer profiling on UNIX systems.

Learn more [here](./objective.md).

## Project Structure

```
.
├── tests                      # C programs for testing the pass
├── branch                     # valgrind directory
│  └── br_main.c               # custom valgrind tool to count instructions
├── scripts
│  ├── setup-vcpkg.sh          # install vcpkg and nlohmann-json
│  ├── ubuntu-install-llvm.sh  # install LLVM 17 on Ubuntu
│  └── valgrind-instruction-count-demo.sh
│── valgrind-extra
│  ├── configure.ac            # copy to valgrind root dir to build the `branch` tool
│  └── Makefile.am
├── BranchPointerPass
│  ├── BranchPointerPass.cpp   # LLVM pass code for key points detection
│  └── CMakeLists.txt
├── build                      # build directory
├── CMakeLists.txt
├── inputs
│  └── input.c                 # trivial c program for testing LLVM pass
├── Makefile
├── objective.md
└── README.md

```

> [!NOTE]
> Things to lookout for when running the pass:
> - Make sure [nlohmann-json](https://github.com/nlohmann/json) is installed
> - Make sure the LLVM include dir and [nlohmann-json](https://github.com/nlohmann/json) include dir are included in `BranchPointerPass/CMakeLists.txt`
> - **If on Ubuntu, running `make || make` will set up everything for you**, including installation of LLVM 17, vcpkg, and nlohmann-json. `make` will invoke a few scripts to install these dependencies and build the pass. You may be asked to press <kbd>Enter</kbd> to accept LLVM's license agreement. Read [`Makefile`](./Makefile) for more details.
> - If you see this error `CMake Error: CMake was unable to find a build program corresponding to "Unix Makefiles".  CMAKE_MAKE_PROGRAM is not set.  You probably need to select a different build tool.` when running `make`, please re-run the command - sometimes it takes a few tries to get it to work.


## Prerequisites
> [!IMPORTANT]
> Please use a **clean** VCL VM to follow through, otherwise you might get weird errors here or there, because of LLVM versions / installation method / installation locations / etc.

> [!TIP]
> If on Ubuntu, just run `make prereq` to install everything automatically (you may be asked to press <kbd>Enter</kbd> to accept LLVM's license agreement). Read [`Makefile`](./Makefile) for more details.
- LLVM >= 16.0 installed (`./scripts/ubuntu-install-llvm.sh`)
- CMake installed (`sudo apt install cmake -y`)
- C++ compiler (e.g., g++, clang)

### 3rd party libraries

install these libraries and include your include paths on your system to `BranchPointerPass/CMakeLists.txt`:

- [nlohmann-json](https://github.com/nlohmann/json)





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
make run
# you can specify the LLVM installation directory and clang and opt commands as follows:
# make LLVM_DIR=/usr/lib/llvm-17 CLANG_COMMAND=/usr/bin/clang-17 OPT_COMMAND=/usr/bin/opt-17
```

Replace `input.ll` with the LLVM IR file you want to analyze.

## Output


```
$ make

-- Configuring done (0.2s)
-- Generating done (0.0s)
-- Build files have been written to: /Users/tscp/testdir/csc512-proj/part1-dev/build
gmake[1]: Entering directory '/Users/tscp/testdir/csc512-proj/part1-dev/build'
[100%] Built target BranchPointerPass
gmake[1]: Leaving directory '/Users/tscp/testdir/csc512-proj/part1-dev/build'
opt -load-pass-plugin ./build/BranchPointerPass/libBranchPointerPass.so -passes=branch-pointer-pass -disable-output inputs/input.ll
*funcptr_0x6000008d8380
br_1: /Users/tscp/testdir/csc512-proj/part1-dev/inputs/input.c, 12, 13
br_2: /Users/tscp/testdir/csc512-proj/part1-dev/inputs/input.c, 13, 13
br_3: /Users/tscp/testdir/csc512-proj/part1-dev/inputs/input.c, 13, 14
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

## Technical Details

### optimization flags

I tested the pass on .ll files generated by clang with or without `-O0`, both gave the same results.

## Test C programs

They are located in `./tests` directory, all from the [TheAlgorithms/C](https://github.com/TheAlgorithms/C) repository, and are real-world programs, each program is around 700 lines.

Please note that they require C standard of at least C99.

```
tests
├── hash_blake2b.c
├── kohonen_som_topology.c
├── mcnaughton_yamada_thompson.c
└── red_black_tree.c
```

## Valgrind instruction count

See `./branch`

> [!TIP]
> For a quick demo that automatically builds the tool and run instruction count instrumentation on `date` binary, run
> `./scripts/valgrind-instruction-count-demo.sh`

### Building

```bash
# get valgrind source if you haven't already
git clone https://sourceware.org/git/valgrind.git && cd valgrind

# copy `./branch` dir, ./valgrind-extra/* to `valgrind` dir
# cp -vr "$REPO_ROOT/branch" .
# VALGRIND_EXTRA_DIR="$REPO_ROOT/valgrind-extra"
# cp -vf "$VALGRIND_EXTRA_DIR/configure.ac" .
# cp -vf "$VALGRIND_EXTRA_DIR/Makefile.am" .


# then run these from the root of the valgrind dir
./autogen.sh
 ./configure --prefix=`pwd`/inst
 make install
```

### Usage

```bash
# from the root of the valgrind dir
inst/bin/valgrind --tool=branch date
# or replace `date` with any executable you compiled
```

### Output

Running on Ubuntu 22.04 on VCL

```
# ./input is compiled from `inputs/input.c` using g++
# running from the root of the valgrind dir
$ inst/bin/valgrind --tool=branch ./input

==2502571== Branch, a binary profiling tool to count instructions
==2502571== Copyright (C) 2002-2017, and GNU GPL'd, by Teddy Xinyuan Chen
==2502571== Using Valgrind-3.23.0.GIT and LibVEX; rerun with -h for copyright info
==2502571== Command: ./input
==2502571== 
Foo: 0
Bar: 1
Foo: 2
Bar: 3
==2502571== 
==2502571== Total number of executed instructions: 138983
```