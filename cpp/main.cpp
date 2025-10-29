#include <cstdio>

#include "manage_references.h"
#include "error_checking.h"
#include "managed_concurrency.h"

int main(){

    ManageReferences::manage_references();

    ErrorChecking::check_errors();

    ManagedConcurrency::manage_concurrency();

    printf("CPP: Hello World!\n");
    return 0;
}
