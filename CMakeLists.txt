cmake_minimum_required(VERSION 3.5)
project(LogicalVision2)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp src/prolog2/cvatari.cpp, src/prolog2/cvio.cpp, src/prolog2/cvdraw.cpp, src/prolog2/cvsampler.cpp)
add_executable(LogicalVision2 ${SOURCE_FILES})

include_directories(${LD_LIBRARY_PATH})

find_package(OpenCV REQUIRED)
find_package(Qt5Gui REQUIRED)
find_package(swipl REQUIRED)

target_link_libraries(LogicalVision2 ${OpenCV_LIBS})
target_link_libraries(LogicalVision2 ${Qt5Gui_LIBS})
target_link_libraries(LogicalVision2 ${swipl_LIBS})
