cmake_minimum_required(VERSION 3.10)
project(cocoa_stream)

set(CMAKE_CXX_STANDARD 17)

add_executable(cocoa_stream main.cc network.h network.mm)

find_library(Foundation Foundation)
target_link_libraries(cocoa_stream ${Foundation})
