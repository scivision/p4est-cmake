cmake_minimum_required(VERSION 3.15)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()

project(P4EST
  LANGUAGES C
  DESCRIPTION "Build and use p4est (autotools-based) from CMake projects"
  HOMEPAGE_URL https://github.com/cburstedde/p4est)

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
message(VERBOSE "CMake ${CMAKE_VERSION} using ${Ncpu} threads")

# --- prereqs
find_package(Autotools REQUIRED)

if(NOT TARGET MPI::MPI_C)
  find_package(MPI COMPONENTS C)
endif()

# --- p4est installed?
if(NOT p4est_external)
  find_package(p4est)
endif()

# --- build p4est if needed
if(p4est_external OR NOT p4est_FOUND)
  include(cmake/p4est.cmake)
endif()

# --- user programs
if(BUILD_TESTING)
  add_executable(hello hello.c)
  target_link_libraries(hello PRIVATE p4est::p4est)

  if(MPI_C_FOUND)
    target_link_libraries(hello PRIVATE MPI::MPI_C)
    add_test(NAME p4est:hello COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_MAX_NUMPROCS} $<TARGET_FILE:hello>)
  else(MPI_C_FOUND)
    add_test(NAME p4est:hello COMMAND $<TARGET_FILE:hello>)
  endif(MPI_C_FOUND)
endif(BUILD_TESTING)
