%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror(const char *s){ fprintf(stderr,"Type error: %s\n", s); }
typedef enum {T_INT, T_FLOAT, T_ERR} Type;
typedef struct { Type type; char *name; } Attr;
#define YYSTYPE_IS_DECLARED 1
typedef struct { Type type; char *name; } YYSTYPE;
%}
%token INT FLOAT ID INT_CONST FLOAT_CONST
%left '+' '-'
%left '*' '/'
%%
program: decls stmts
       ;
decls: /* empty */
     | decls decl
     ;
decl: INT ID ';' { /* store type */ printf("Decl: %s as int\n", $2); /* in real implementation insert into symbol table */ }
    | FLOAT ID ';' { printf("Decl: %s as float\n", $2); }
    ;
stmts: /* empty */
     | stmts stmt
     ;
stmt: ID '=' expr ';' {
        /* naive type-check: here we must fetch ID type from symtab. For demo, we check expr type and assume declared int */
        if($3.type==T_ERR) { yyerror("rhs type error"); }
        else printf("Assignment to %s ok (rhs type %s)\n", $1, $3.type==T_INT?"int":"float");
     }
    ;
expr: expr '+' expr {
        YYSTYPE res;
        if($1.type==T_ERR || $3.type==T_ERR) res.type=T_ERR;
        else if($1.type==T_FLOAT || $3.type==T_FLOAT) res.type=T_FLOAT;
        else res.type=T_INT;
        $$ = res;
     }
    | INT_CONST { YYSTYPE r; r.type=T_INT; $$ = r; }
    | FLOAT_CONST { YYSTYPE r; r.type=T_FLOAT; $$ = r; }
    | ID { /* lookup ID type, assume int for demo */ YYSTYPE r; r.type=T_INT; $$=r; }
    ;
%%
int main(){ printf("Type checking (demo):\n"); yyparse(); return 0; }
