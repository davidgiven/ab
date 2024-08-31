#include <stdio.h>

#ifndef CHEADER
#error CHEADER not defined
#endif

#include "headers/test.h"

#ifndef HEADER_INCLUDED
#error HEADER_INCLUDED not defined
#endif

int main(int argc, const char* argv[])
{
    printf("Hello, world!\n");
    return 0;
}
