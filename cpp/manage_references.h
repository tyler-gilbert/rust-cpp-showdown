

#ifndef MANAGE_REFERENCES_H
#define MANAGE_REFERENCES_H

#include <cstdio>

class ManageReferences {
public:
  // All lifetimes are managed by the developer when using references.
  static const int &get_reference(const int &value) { return value; }
  static int &get_reference_mut(int &value) { return value; }

  static void manage_references() {
    const int value = 42;
    const int &reference{get_reference(value)};
    printf("CPP: reference %d\n", reference);
    int value_mut = value;
    int &reference_mut{get_reference_mut(value_mut)};
    reference_mut = 100;
    printf("CPP: reference mut %d\n", reference_mut);
  }
};

#endif
