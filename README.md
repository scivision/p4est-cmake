# p4est-cmake

![ci](https://github.com/scivision/p4est-cmake/workflows/ci/badge.svg)

Building [p4est](https://github.com/cburstedde/p4est) as a CMake ExternalProject for easier use in CMake projects in an OS-agnostic manner.

The CMake script runs `bootstrap`, `configure`, `make`, `make install`, `make check`.
On a desktop or good laptop PC it takes about 5 minutes to build and test.

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
