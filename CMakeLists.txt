cmake_minimum_required(VERSION 3.13)

include(cmake/compiler_find.cmake)
find_c()

project(P4EST
  LANGUAGES C
  DESCRIPTION "Build and use p4est (autotools-based) from CMake projects"
  HOMEPAGE_URL https://github.com/cburstedde/p4est)

include(CTest)

option(p4est_external "build p4est")
option(P4EST_BUILD_TESTING "p4est self tests" OFF)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

find_package(Autotools)
if(NOT Autotools_FOUND)
  message(FATAL_ERROR "Please install Autotools--see the Readme docs")
endif()

find_package(MPI COMPONENTS C)

if(NOT p4est_external)
  find_package(p4est)
endif()

if(p4est_external OR NOT p4est_FOUND)
  include(cmake/p4est.cmake)
endif()
# --- user programs

add_executable(hello hello.c)
target_link_libraries(hello PRIVATE p4est::p4est)
if(MPI_C_FOUND)
  target_link_libraries(hello PRIVATE MPI::MPI_C)
  add_test(NAME p4est:hello COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:hello>)
else(MPI_C_FOUND)
  add_test(NAME p4est:hello COMMAND $<TARGET_FILE:hello>)
endif(MPI_C_FOUND)