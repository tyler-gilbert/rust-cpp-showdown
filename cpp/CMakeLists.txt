cmake_minimum_required(VERSION 3.20)
set(CMAKE_TOOLCHAIN_FILE $ENV{SPACES_WORKSPACE}/llvm-19-toolchain.cmake)
project(cpp_project)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_executable(cpp main.cpp)
