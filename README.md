# p4est-cmake

![ci](https://github.com/scivision/p4est-cmake/workflows/ci/badge.svg)

Building [p4est](https://github.com/cburstedde/p4est) as a CMake ExternalProject for easier use in CMake projects on Linux and MacOS.
Windows has platform-specific issues (no autotools), so it is probably easier to use p4est via Windows Subsystem for Linux.

## Usage

As with most CMake projects:

```sh
cmake -B build
cmake --build build
```

This project consumes p4est as an
[ExternalProject](https://cmake.org/cmake/help/latest/module/ExternalProject.html).
p4est is downloaded, built, and tested on the `cmake --build` command.

### Artifacts

Binary artifacts (test executables) are created under "build/".

* bin: test executables
* include: *.h headers
* lib: p4est, sc

## Prereqs

p4est needs a few libraries and programs to build.

### Linux

The names of these packages vary slightly depending on Linux distro. On Ubuntu:

```sh
apt install gcc cmake make libopenmpi-dev autoconf automake libtool
```

### MacOS

assuming Homebrew is used:

```sh
brew install gcc cmake make openmpi autoconf automake
```
