include(ExternalProject)

set(p4est_external true CACHE BOOL "build p4est library")

function(build_p4est)

set(_ld ${PROJECT_BINARY_DIR}/lib)

set(p4est_LIBRARY ${_ld}/${CMAKE_STATIC_LIBRARY_PREFIX}p4est${CMAKE_STATIC_LIBRARY_SUFFIX} CACHE FILEPATH "p4est library" FORCE)
set(sc_LIBRARY ${_ld}/${CMAKE_STATIC_LIBRARY_PREFIX}sc${CMAKE_STATIC_LIBRARY_SUFFIX} CACHE FILEPATH "sc library" FORCE)

set(p4est_flags --prefix=${PROJECT_BINARY_DIR})
set(p4est_mpi)
if(MPI_C_FOUND)
  set(p4est_mpi --enable-mpi)
endif()

ExternalProject_Add(p4est
GIT_REPOSITORY https://github.com/cburstedde/p4est.git
GIT_TAG prev3-develop
# v2.2 requires BLAS and has problems detecting gfortran on MacOS
UPDATE_DISCONNECTED true  # need this to avoid constant rebuild
CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/p4est-prefix/src/p4est/configure ${p4est_flags} ${p4est_mpi}
BUILD_COMMAND make -j${Ncpu}
INSTALL_COMMAND make -j${Ncpu} install
TEST_COMMAND ""
BUILD_BYPRODUCTS ${p4est_LIBRARY} ${sc_LIBRARY}
)

ExternalProject_Get_Property(p4est SOURCE_DIR)

ExternalProject_Add_Step(p4est
  bootstrap
  COMMAND ./bootstrap
  DEPENDEES download
  DEPENDERS configure
  WORKING_DIRECTORY ${SOURCE_DIR})

set(p4est_LIBRARIES ${p4est_LIBRARY} ${sc_LIBRARY} PARENT_SCOPE)

endfunction(build_p4est)

build_p4est()

# --- imported target
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/include)  # avoid race condition

add_library(p4est::p4est INTERFACE IMPORTED GLOBAL)
target_include_directories(p4est::p4est INTERFACE ${PROJECT_BINARY_DIR}/include)
target_link_libraries(p4est::p4est INTERFACE "${p4est_LIBRARIES}")  # need the quotes to expand list
# set_target_properties didn't work, but target_link_libraries did work

add_dependencies(p4est::p4est p4est)
