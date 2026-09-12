cmake_minimum_required(VERSION 3.19)

project(CPS_CA1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(CPS_CA1
    src/mux.cpp
)

target_include_directories(CPS_CA1
    PRIVATE
        ${CMAKE_SOURCE_DIR}/include
)

target_include_directories(CPS_CA1
    PRIVATE
        ${CMAKE_SOURCE_DIR}/boost_1_84_0
)