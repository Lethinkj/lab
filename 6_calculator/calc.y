%{
#include <stdio.h>
#include <stdlib.h>
typedef double dval;
typedef struct { dval d; } YYSTYPE;
#define YYSTYPE_IS_DECLARED 1
int yylex(void);
void yyerror(const char *s){ fprintf(stderr,"Error: %s\n", s); }
%token EOL NUM
%left '+' '-'
%left '*' '/'
%%
input: /* empty */
     | input line
     ;
line: expr EOL { printf("= %g\n", $1); }
    ;
expr: expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { if($3==0) { yyerror("divide by zero"); $$=0; } else $$ = $1 / $3; }
    | '(' expr ')'  { $$ = $2; }
    | NUM           { $$ = $1; }
    ;
%%
int main(){
  printf("Calc: type expression and press Enter (Ctrl+D to quit)\n");
  yyparse();
  return 0;
}
