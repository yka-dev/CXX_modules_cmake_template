cmake_minimum_required(VERSION 3.28)
project(project LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(cmake/ModuleTargets.cmake)

file(GLOB lib_cmakes CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/lib/*/CMakeLists.txt")
file(GLOB cmd_cmakes CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/cmd/*/CMakeLists.txt")

foreach(cm IN LISTS lib_cmakes cmd_cmakes)
    get_filename_component(dir "${cm}" DIRECTORY)
    add_subdirectory("${dir}")
endforeach()
