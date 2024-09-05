module;

#include <stdio.h>

export module cxxmodule_compile_test;

export namespace cxxmodule_compile_test
{
    void hello()
    {
        printf("Hello from a module!\n");
    }
}