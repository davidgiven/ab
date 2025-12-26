%option noyywrap

%{
#include <stdlib.h>
#include "y.tab.h"
%}

%%
[0-9]+ { return INT; }
.|\n ;
%%