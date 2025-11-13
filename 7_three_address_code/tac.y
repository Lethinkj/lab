%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror(const char *s){ fprintf(stderr,"Parse error: %s\n",s); }
int tempcount=0;
char* newtemp(){ char buf[16]; sprintf(buf,"t%d",++tempcount); return strdup(buf); }
void emit(char *op, char *arg1, char *arg2, char *res){
    printf("(%s, %s, %s, %s)\n", op?op:"", arg1?arg1:"", arg2?arg2:"", res?res:"");
}
typedef struct { char *place; } YYSTYPE;
#define YYSTYPE_IS_DECLARED 1
%}
%token NUM ID
%left '+' '-'
%left '*' '/'
%%
program: stmt_list
       ;
stmt_list: stmt_list stmt
         | stmt
         ;
stmt: ID '=' expr ';' { emit("=", $3->place, "", $1); }
    ;
expr: expr '+' expr {
           char *t=newtemp();
           emit("+", $1->place, $3->place, t);
           $$ = malloc(sizeof(*$$)); $$->place = t;
       }
    | expr '-' expr {
           char *t=newtemp();
           emit("-", $1->place, $3->place, t);
           $$ = malloc(sizeof(*$$)); $$->place = t;
       }
    | expr '*' expr {
           char *t=newtemp();
           emit("*", $1->place, $3->place, t);
           $$ = malloc(sizeof(*$$)); $$->place = t;
       }
    | expr '/' expr {
           char *t=newtemp();
           emit("/", $1->place, $3->place, t);
           $$ = malloc(sizeof(*$$)); $$->place = t;
       }
    | '(' expr ')' { $$ = $2; }
    | NUM {
           char *t=newtemp();
           char tmpbuf[32]; sprintf(tmpbuf,"%d", $1);
           /* for simplicity, immediate constant put into temp */
           emit(":=CONST", tmpbuf, "", t);
           $$ = malloc(sizeof(*$$)); $$->place = strdup(t);
       }
    | ID {
           $$ = malloc(sizeof(*$$)); $$->place = strdup($1);
       }
    ;
%%
int main(){ printf("Three-Address Code (quadruples):\n"); yyparse(); return 0; }
