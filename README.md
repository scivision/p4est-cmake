# p4est-cmake

![ci](https://github.com/scivision/p4est-cmake/workflows/ci/badge.svg)
![ci_mac](https://github.com/scivision/p4est-cmake/workflows/ci_mac/badge.svg)

Building [p4est](https://github.com/cburstedde/p4est) as a CMake ExternalProject for easier use in CMake projects on Linux and MacOS.
Windows has platform-specific issues, so it is probably easier to use p4est via Windows Subsystem for Linux.

The CMake script runs `bootstrap`, `configure`, `make`, `make install`, `make check`.
On a good desktop PC it takes about 2 minutes to build and test p4est.

## Usage

As with most CMake projects:

```sh
cmake -B build

cmake --build build --parallel
```

Since this project consumes p4est as an [ExternalProject](https://cmake.org/cmake/help/latest/module/ExternalProject.html), p4est is downloaded, built, and tested on the "cmake --build" command.

### Artifacts

Binary artifacts (test exectuables) are created under "build/".

* bin: test exectuables
* include: *.h headers
* lib: p4est, sc

### Prereqs

MacOS: assuming Homebrew is used:

```sh
brew install gcc cmake make openmpi autoconf automake libtool lapack
```
