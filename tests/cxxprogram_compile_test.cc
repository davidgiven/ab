#include <iostream>

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
    return 0;
}
