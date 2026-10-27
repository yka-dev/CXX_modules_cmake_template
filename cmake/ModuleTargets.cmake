include_guard(GLOBAL)

function(_glob var)
    file(GLOB_RECURSE found CONFIGURE_DEPENDS ${ARGN})
    set(${var} ${found} PARENT_SCOPE)
endfunction()

function(_add_module_sources name)
    set(dir "${CMAKE_CURRENT_SOURCE_DIR}")

    _glob(pub_modules  "${dir}/pub/*.ccm")
    _glob(priv_modules "${dir}/src/*.ccm")
    _glob(sources      "${dir}/src/*.cc")

    if(pub_modules)
        target_sources(${name} PUBLIC
            FILE_SET CXX_MODULES BASE_DIRS "${dir}/pub" FILES ${pub_modules})
    endif()
    if(priv_modules)
        target_sources(${name} PRIVATE
            FILE_SET priv_modules TYPE CXX_MODULES BASE_DIRS "${dir}/src" FILES ${priv_modules})
    endif()
    if(sources)
        target_sources(${name} PRIVATE ${sources})
    endif()

    if(IS_DIRECTORY "${dir}/pub")
        target_include_directories(${name} PUBLIC "${dir}/pub")
    endif()
    if(IS_DIRECTORY "${dir}/src")
        target_include_directories(${name} PRIVATE "${dir}/src")
    endif()
endfunction()

function(add_module_lib name)
    cmake_parse_arguments(ARG "SHARED" "" "DEPS" ${ARGN})

    if(ARG_SHARED)
        add_library(${name} SHARED)
    else()
        add_library(${name} STATIC)
    endif()

    _add_module_sources(${name})

    if(ARG_DEPS)
        target_link_libraries(${name} PUBLIC ${ARG_DEPS})
    endif()
endfunction()

function(add_module_app name)
    cmake_parse_arguments(ARG "" "" "DEPS" ${ARGN})
    add_executable(${name})
    _add_module_sources(${name})
    if(ARG_DEPS)
        target_link_libraries(${name} PRIVATE ${ARG_DEPS})
    endif()

    add_custom_target(run-${name}
        COMMAND ${name}
        DEPENDS ${name}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        USES_TERMINAL
        COMMENT "Running ${name}"
        VERBATIM)
endfunction()
