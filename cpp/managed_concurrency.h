

#ifndef MANAGED_CONCURRENCY_H
#define MANAGED_CONCURRENCY_H

#include <cstdio>

#include <thread>
#include <mutex>

class ManagedConcurrency {
public:

  static void manage_concurrency() {
      // concurrency
          std::mutex mutex;
          // mutex and value are decoupled
          // variables on mut by default, use const to make read-only
          int inner{10};

          std::thread handle0([&mutex, &inner]{
              std::lock_guard<std::mutex> _guard{mutex};
              // access data protected by mutex
              printf("CPP: Initial value is %d\n", inner);
              inner += 5;
              printf("CPP: Updated value is %d\n", inner);
          });

          std::thread handle1([&mutex, &inner]{
              std::lock_guard<std::mutex> _guard{mutex};
              // access data protected by mutex
              printf("CPP: Initial value is %d\n", inner);
              inner += 5;
              printf("CPP: Updated value is %d\n", inner);
          });

          // unjoined threads become zombies
          // use std::jthread to join on destruct
          handle0.join();
          handle1.join();
  }
};

#endif
