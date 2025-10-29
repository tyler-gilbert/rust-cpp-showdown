

#ifndef ERROR_CHECKING_H
#define ERROR_CHECKING_H

#include <cstdio>
#include <fstream>
#include <iostream>
#include <string>
#include <fcntl.h>
#include <unistd.h>

class ErrorChecking {
public:
  struct Result {
    int value{};
    std::string message;
  };

  // std::expected works like Result part of C++23

  static Result this_is_an_error() { return Result{{}, "This is an error"}; }

  static Result this_is_a_nested_yet_another_nested_call() {
    return this_is_an_error();
  }

  static Result this_is_a_nested_another_nested_call() {
    return this_is_a_nested_yet_another_nested_call();
  }

  static Result this_is_a_nested_call() {
    return this_is_a_nested_another_nested_call();
  }

  static std::string get_file_contents(std::string_view path) { return {}; }

  static void check_errors() {
    try {
      std::string contents{get_file_contents("my_file.txt")};
    } catch (const std::exception &e) {
      std::cerr << "CPP:Error: " << e.what() << std::endl;
    }

    int fd = open("my_file.txt", O_RDONLY);
    if (fd == -1) {
      std::cerr << "CPP:Error: Failed to open file" << std::endl;
    }

    char buffer[1024];
    ssize_t bytes_read = read(fd, buffer, sizeof(buffer));
    if (bytes_read == -1) {
      std::cerr << "CPP:Error: Failed to read file" << std::endl;
    }

    const Result result{this_is_a_nested_call()};
    if (!result.message.empty()) {
      std::cerr << "CPP: Error: " << result.message << std::endl;
    }
  }
};

#endif
