# - Find the NumPy libraries
# This module finds if NumPy is installed, and sets the following variables
# indicating where it is.
#
# TODO: Update to provide the libraries and paths for linking npymath lib.
#
#  NumPy_FOUND               - was NumPy found
#  NumPy_VERSION             - the version of NumPy found as a string
#  NumPy_VERSION_MAJOR       - the major version number of NumPy
#  NumPy_VERSION_MINOR       - the minor version number of NumPy
#  NumPy_VERSION_PATCH       - the patch version number of NumPy
#  NumPy_VERSION_DECIMAL     - e.g. version 1.6.1 is 10601
#  NumPy_INCLUDE_DIRS        - path to the NumPy include files

#============================================================================
# Copyright 2012 Continuum Analytics, Inc.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
#============================================================================

# Finding NumPy involves calling the Python interpreter
if(NumPy_FIND_REQUIRED)
    find_package(PythonInterp REQUIRED)
else()
    find_package(PythonInterp)
endif()

if(NOT PYTHONINTERP_FOUND)
    set(NumPy_FOUND FALSE)
    return()
endif()

execute_process(COMMAND "${PYTHON_EXECUTABLE}" "-c"
    "import numpy as n; print(n.__version__); print(n.get_include());"
    RESULT_VARIABLE _NumPy_SEARCH_SUCCESS
    OUTPUT_VARIABLE _NumPy_VALUES_OUTPUT
    ERROR_VARIABLE _NumPy_ERROR_VALUE
    OUTPUT_STRIP_TRAILING_WHITESPACE)

if(NOT _NumPy_SEARCH_SUCCESS MATCHES 0)
    if(NumPy_FIND_REQUIRED)
        message(FATAL_ERROR
            "NumPy import failure:\n${_NumPy_ERROR_VALUE}")
    endif()
    set(NumPy_FOUND FALSE)
    return()
endif()

# Convert the process output into a list
string(REGEX REPLACE ";" "\\\\;" _NumPy_VALUES ${_NumPy_VALUES_OUTPUT})
string(REGEX REPLACE "\n" ";" _NumPy_VALUES ${_NumPy_VALUES})
# Just in case there is unexpected output from the Python command.
list(GET _NumPy_VALUES -2 NumPy_VERSION)
list(GET _NumPy_VALUES -1 NumPy_INCLUDE_DIRS)

string(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" _VER_CHECK "${NumPy_VERSION}")
if("${_VER_CHECK}" STREQUAL "")
    # The output from Python was unexpected. Raise an error always
    # here, because we found NumPy, but it appears to be corrupted somehow.
    message(FATAL_ERROR
        "Requested version and include path from NumPy, got instead:\n${_NumPy_VALUES_OUTPUT}\n")
    return()
endif()

# Make sure all directory separators are '/'
string(REGEX REPLACE "\\\\" "/" NumPy_INCLUDE_DIRS ${NumPy_INCLUDE_DIRS})

# Get the major and minor version numbers
string(REGEX REPLACE "\\." ";" _NumPy_VERSION_LIST ${NumPy_VERSION})
list(GET _NumPy_VERSION_LIST 0 NumPy_VERSION_MAJOR)
list(GET _NumPy_VERSION_LIST 1 NumPy_VERSION_MINOR)
list(GET _NumPy_VERSION_LIST 2 NumPy_VERSION_PATCH)
string(REGEX MATCH "[0-9]*" NumPy_VERSION_PATCH ${NumPy_VERSION_PATCH})
math(EXPR NumPy_VERSION_DECIMAL
    "(${NumPy_VERSION_MAJOR} * 10000) + (${NumPy_VERSION_MINOR} * 100) + ${NumPy_VERSION_PATCH}")

find_package_message(NumPy
    "Found NumPy: version \"${NumPy_VERSION}\" ${NumPy_INCLUDE_DIRS}"
    "${NumPy_INCLUDE_DIRS}${NumPy_VERSION}")

set(NumPy_FOUND TRUE)
