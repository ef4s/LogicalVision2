cmake_minimum_required(VERSION 3.5)
project(LogicalVision2)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp src/prolog2/cvatari.cpp src/prolog2/cvatari.h)
add_executable(LogicalVision2 ${SOURCE_FILES})

include_directories(${LD_LIBRARY_PATH})