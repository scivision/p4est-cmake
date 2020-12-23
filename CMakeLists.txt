cmake_minimum_required(VERSION 3.13)

include(cmake/compiler_find.cmake)
find_c()

project(p4est
  LANGUAGES C
  DESCRIPTION "Build and use p4est (autotools-based) from CMake projects"
  HOMEPAGE_URL https://github.com/cburstedde/p4est)

include(CTest)

set(P4EST_ROOT ${PROJECT_BINARY_DIR})
set(p4est_src ${P4EST_ROOT}/src/p4est)

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
message(STATUS "CMake ${CMAKE_VERSION} using ${Ncpu} threads")

# --- help autotools based on CMake variables

find_package(MPI COMPONENTS C)

set(p4est_flags --prefix=${P4EST_ROOT})
set(p4est_mpi)
if(MPI_C_FOUND)
  set(p4est_mpi --enable-mpi)
endif()

include(ExternalProject)

if(BUILD_TESTING)
  set(p4est_test_cmd make check)
else()
  set(p4est_test_cmd "")
endif()

ExternalProject_Add(p4est
GIT_REPOSITORY https://github.com/cburstedde/p4est.git
GIT_TAG prev3-develop
# v2.2 requires BLAS and has problems detecting gfortran on MacOS
GIT_SHALLOW true
UPDATE_DISCONNECTED true
PREFIX ${P4EST_ROOT}
CONFIGURE_COMMAND ${p4est_src}/configure ${p4est_flags} ${p4est_mpi}
BUILD_COMMAND make -j${Ncpu}
INSTALL_COMMAND make -j${Ncpu} install
TEST_COMMAND ${p4est_test_cmd}
)

ExternalProject_Get_Property(p4est SOURCE_DIR)

ExternalProject_Add_Step(p4est
  bootstrap
  COMMAND ./bootstrap
  DEPENDEES download
  DEPENDERS configure
  WORKING_DIRECTORY ${SOURCE_DIR})
