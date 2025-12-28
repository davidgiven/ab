%{
#include <stdlib.h>
#include "y.tab.h"
%}

%option noyywrap
%%
[0-9]+ { return INT; }
.|\n ;
%%