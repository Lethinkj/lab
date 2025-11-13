%{
#include <stdio.h>
#include <stdlib.h>
typedef struct { int num; } YYSTYPE;
#define YYSTYPE_IS_DECLARED 1
int yylex(void);
void yyerror(const char *s){ fprintf(stderr,"Syntax error: %s\n", s); }
%}
%token NUM
%left '+' '-'
%left '*' '/'
%%
input: expr { printf("Accepted\n"); }
     ;
expr: expr '+' expr { }
    | expr '-' expr { }
    | expr '*' expr { }
    | expr '/' expr { }
    | '(' expr ')'   { }
    | NUM            { }
    ;
%%
int main(){ printf("Enter expression:\n"); if(yyparse()==0) return 0; else return 1; }
