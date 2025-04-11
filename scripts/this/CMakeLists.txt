cmake_minimum_required(VERSION 3.12)

# dynamically set the project name
get_filename_component(PROJECT_NAME ${CMAKE_SOURCE_DIR} NAME)
project(${PROJECT_NAME})

# check if global environment variable `UMFELD_ROOT` is set
# this will allow you to have the project in any location
# while still being able to use the same umfeld lib
if(NOT DEFINED ENV{UMFELD_ROOT})
    set(UMFELD_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../umfeld") # set path to umfeld library
else()
    set(UMFELD_PATH "$ENV{UMFELD_ROOT}")
endif()

# --------- no need to change anything below this line ------------

set(CMAKE_CXX_STANDARD 17)                                         # set c++ standard, this needs to happen before `add_executable`
set(CMAKE_CXX_STANDARD_REQUIRED ON)                                # minimum is C++17 but 20 and 23 should also be fine

include_directories(".")                                           # add all `.h` header files from this directory
file(GLOB SOURCE_FILES "*.cpp")                                    # collect all `.cpp` source files from this directory
add_executable(${PROJECT_NAME} ${SOURCE_FILES})                    # add source files to application

add_subdirectory(${UMFELD_PATH} ${CMAKE_BINARY_DIR}/umfeld-lib-${PROJECT_NAME}) # add umfeld location
add_umfeld_libs()                                                # add umfeld library

