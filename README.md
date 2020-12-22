# p4est-cmake

Building [p4est](https://github.com/cburstedde/p4est) as a CMake ExternalProject for easier use in CMake projects in an OS-agnostic manner.

The CMake script runs `bootstrap`, `configure`, `make`, `make install`, `make check`.
On a desktop/beefy laptop it takes about:

* < 1 minute Git clone
* 3-5 minutes: bootstrap
* 1-2 minutes: configure
* 5 minutes: build (in parallel)
