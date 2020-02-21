cmake_minimum_required(VERSION 3.0)

project(matplotlibcpp VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)

LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Call find_package(PythonInterp) first to get the currently active Python version and use that for
# setting the version to find for find_package(PythonLibs)
find_package(PythonInterp REQUIRED)
set(Python_ADDITIONAL_VERSIONS ${PYTHON_VERSION_STRING})
find_package(PythonLibs REQUIRED)

find_package(NumPy) # In case numpy headers are at non-standard locations

add_library(${PROJECT_NAME} INTERFACE)
target_include_directories(${PROJECT_NAME} INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_include_directories(${PROJECT_NAME} INTERFACE ${PYTHON_INCLUDE_DIRS} ${NumPy_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} INTERFACE ${PYTHON_LIBRARIES})
if(NOT NumPy_FOUND)
    target_compile_definitions(${PROJECT_NAME} INTERFACE "-DWITHOUT_NUMPY")
else()
    set(NUMPY_DEP "NumPy")
endif()

install(TARGETS ${PROJECT_NAME} EXPORT "${PROJECT_NAME}Targets"
  LIBRARY DESTINATION "lib"
  ARCHIVE DESTINATION "lib"
  RUNTIME DESTINATION "bin"
  INCLUDES DESTINATION "include"
  )

install(DIRECTORY "include/${PROJECT_NAME}"
  DESTINATION "include"
  FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
  PATTERN ".svn" EXCLUDE
  )

if(NumPy_FOUND)
install(FILES cmake/FindNumPy.cmake
  DESTINATION "share/${PROJECT_NAME}/cmake"
  )
endif()

include(cmake/GenerateAndInstallConfig.cmake)
generate_and_install_config_file(
  INCLUDE_DIRS "include"
  LIBRARIES
  DEPS "PythonLibs ${Python_ADDITIONAL_VERSIONS}" ${NUMPY_DEP}
  DEPS_INCLUDE_DIRS PYTHON ${NUMPY_DEP}
  DEPS_LIBRARIES PYTHON
  )

# Examples
option(MATPLOTLIBCPP_EXAMPLES "Build matplotlib examples" OFF)

if(MATPLOTLIBCPP_EXAMPLES)
    add_executable(animation "examples/animation.cpp")
    target_link_libraries(animation matplotlibcpp)

    add_executable(bar "examples/bar.cpp")
    target_link_libraries(bar matplotlibcpp)

    add_executable(basic "examples/basic.cpp")
    target_link_libraries(basic matplotlibcpp)

    add_executable(fill "examples/fill.cpp")
    target_link_libraries(fill matplotlibcpp)

    add_executable(fill_inbetween "examples/fill_inbetween.cpp")
    target_link_libraries(fill_inbetween matplotlibcpp)

    if(NumPy_FOUND)
        add_executable(imshow "examples/imshow.cpp")
        target_link_libraries(imshow matplotlibcpp)
    endif()

    add_executable(minimal "examples/minimal.cpp")
    target_link_libraries(minimal matplotlibcpp)

    add_executable(modern "examples/modern.cpp")
    target_link_libraries(modern matplotlibcpp)

    add_executable(nonblock "examples/nonblock.cpp")
    target_link_libraries(nonblock matplotlibcpp)

    add_executable(quiver "examples/quiver.cpp")
    target_link_libraries(quiver matplotlibcpp)

    add_executable(subplot "examples/subplot.cpp")
    target_link_libraries(subplot matplotlibcpp)

    add_executable(subplot2grid "examples/subplot2grid.cpp")
    target_link_libraries(subplot2grid matplotlibcpp)

    if(NumPy_FOUND)
        add_executable(surface "examples/surface.cpp")
        target_link_libraries(surface matplotlibcpp)
    endif()

    add_executable(update "examples/update.cpp")
    target_link_libraries(update matplotlibcpp)

    add_executable(xkcd "examples/xkcd.cpp")
    target_link_libraries(xkcd matplotlibcpp)
endif(MATPLOTLIBCPP_EXAMPLES)
