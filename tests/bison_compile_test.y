%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%token INT

%%
program:
       program INT { puts("Found integer"); }
       | 
       ;
%%

int main(int argc, char* argv[]) {
    yyin = stdin;
    do {
        yyparse();
    } while (!feof(yyin));
    return 0;
}

void yyerror(const char* s) {
    puts(s);
}