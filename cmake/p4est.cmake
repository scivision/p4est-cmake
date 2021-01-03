# this uses a technique to avoid autotools constantly rebuilding p4est,
# by making the ExternalProject only visible once--until the binaries are built
# then, we use the p4est_FOUND to switch in a dummy target.
# We do the same thing with HDF5 in other projects.

set(p4est_external true CACHE BOOL "build p4est library")

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
message(STATUS "CMake ${CMAKE_VERSION} using ${Ncpu} threads")

# --- help autotools based on CMake variables

include(ExternalProject)

set(p4est_LIBRARIES)
foreach(_l p4est sc)
  list(APPEND p4est_LIBRARIES ${PROJECT_BINARY_DIR}/lib/lib${_l}${CMAKE_STATIC_LIBRARY_SUFFIX})
endforeach()

if(EXISTS ${PROJECT_BINARY_DIR}/lib/libp4est${CMAKE_STATIC_LIBRARY_SUFFIX})
  set(p4est_FOUND true)
endif()

if(NOT p4est_FOUND)

  set(p4est_flags --prefix=${PROJECT_BINARY_DIR})
  set(p4est_mpi)
  if(MPI_C_FOUND)
    set(p4est_mpi --enable-mpi)
  endif()

  if(${PROJECT_NAME}_BUILD_TESTING)
    set(p4est_test make check)
  else()
    set(p4est_test "")
  endif()

  ExternalProject_Add(p4est_proj
  GIT_REPOSITORY https://github.com/cburstedde/p4est.git
  GIT_TAG prev3-develop
  # v2.2 requires BLAS and has problems detecting gfortran on MacOS
  GIT_SHALLOW true
  UPDATE_DISCONNECTED true
  PREFIX ${PROJECT_BINARY_DIR}
  CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/src/p4est_proj/configure ${p4est_flags} ${p4est_mpi}
  BUILD_COMMAND make -j${Ncpu}
  INSTALL_COMMAND make -j${Ncpu} install
  TEST_COMMAND ${p4est_test}
  BUILD_BYPRODUCTS ${PROJECT_BINARY_DIR}/src/p4est_proj-build/src/.libs/libp4est.${CMAKE_STATIC_LIBRARY_SUFFIX}
  )

  ExternalProject_Get_Property(p4est_proj SOURCE_DIR)

  ExternalProject_Add_Step(p4est_proj
    bootstrap
    COMMAND ./bootstrap
    DEPENDEES download
    DEPENDERS configure
    WORKING_DIRECTORY ${SOURCE_DIR})

  file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/include)  # avoid race condition
endif()

add_library(p4est::p4est INTERFACE IMPORTED GLOBAL)
target_include_directories(p4est::p4est INTERFACE ${PROJECT_BINARY_DIR}/include)
target_link_libraries(p4est::p4est INTERFACE ${p4est_LIBRARIES})
# set_target_properties didn't work, but target_link_libraries did work

if(NOT p4est_FOUND)
  add_dependencies(p4est::p4est p4est_proj)
endif()
