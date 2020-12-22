cmake_minimum_required(VERSION 3.12)
project(p4est
  LANGUAGES C
  DESCRIPTION "Build and use p4est (autotools-based) from CMake projects"
  HOMEPAGE_URL https://github.com/cburstedde/p4est)

# --- user parameters
set(P4EST_ROOT ${PROJECT_BINARY_DIR})
set(p4est_src ${P4EST_ROOT}/src/p4est)

# --- main program
find_package(MPI COMPONENTS C)

set(p4est_flags "--prefix=${P4EST_ROOT}")
if(MPI_C_FOUND)
  string(APPEND p4est_flags " --enable-mpi")
endif()

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
message(STATUS "CMake ${CMAKE_VERSION} using ${Ncpu} threads")

include(ExternalProject)

ExternalProject_Add(p4est
GIT_REPOSITORY https://github.com/cburstedde/p4est.git
GIT_TAG v2.2
GIT_SHALLOW true
UPDATE_DISCONNECTED true
PREFIX ${P4EST_ROOT}
CONFIGURE_COMMAND ${p4est_src}/configure ${p4est_flags}
BUILD_COMMAND make -j${Ncpu}
INSTALL_COMMAND make -j${Ncpu} install
TEST_COMMAND make check
)

ExternalProject_Get_Property(p4est SOURCE_DIR)

ExternalProject_Add_Step(p4est
  bootstrap
  COMMAND ./bootstrap
  DEPENDEES download
  DEPENDERS configure
  WORKING_DIRECTORY ${SOURCE_DIR})
