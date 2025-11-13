%{
#include <stdio.h>
#include <stdlib.h>
typedef struct { char *str; } YYSTYPE;
#define YYSTYPE_IS_DECLARED 1
int yylex(void);
void yyerror(const char *s){ fprintf(stderr,"Invalid identifier\n"); }
%}
%token ID
%%
start: ID { printf("Valid identifier: %s\n", $1); }
     ;
%%
int main(){ printf("Enter identifier:\n"); if(yyparse()==0) return 0; else return 1; }
