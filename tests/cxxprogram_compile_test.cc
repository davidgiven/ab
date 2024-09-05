#include <iostream>

#ifndef NO_MODULE
import cxxmodule_compile_test;
#endif

#ifndef CHEADER
#error CHEADER not defined
#endif

#include "headers/test.h"

#ifndef HEADER_INCLUDED
#error HEADER_INCLUDED not defined
#endif

int main(int argc, const char* argv[])
{
    std::cout << "Hello, world!\n";
    #ifndef NO_MODULE
        cxxmodule_compile_test::hello();
    #endif
    return 0;
}
