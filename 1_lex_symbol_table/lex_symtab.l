%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SYMTAB_SIZE 997
typedef struct Node { char *name; struct Node *next; } Node;
Node* symtab[SYMTAB_SIZE];

unsigned hash(const char *s){
    unsigned h=0; while(*s) h = (h<<5)+h + (unsigned char)*s++;
    return h % SYMTAB_SIZE;
}
void add_id(const char *s){
    unsigned h=hash(s);
    Node *p=symtab[h];
    while(p){ if(strcmp(p->name,s)==0) return; p=p->next; }
    Node *n=malloc(sizeof(Node)); n->name=strdup(s); n->next=symtab[h]; symtab[h]=n;
}
void print_symtab(){
    printf("\n--- Symbol Table ---\n");
    for(int i=0;i<SYMTAB_SIZE;i++){
        for(Node *p=symtab[i]; p; p=p->next) printf("%s\n", p->name);
    }
}
%}

%%
"/*"([^*]|\*+[^*/])*\*+ "/"          { /* skip comments */ }
"//".*                              { /* skip // comment */ }
[ \t\r\n]+                          { /* skip whitespace */ }
"int"|"float"|"char"|"double"|"return"|"if"|"else"|"for"|"while"   { printf("KEYWORD\t%s\n", yytext); }
[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?  { printf("CONSTANT\t%s\n", yytext); }
\"([^\\\"]|\\.)*\"                   { printf("STRING_LITERAL\t%s\n", yytext); }
"=="|"!="|"<="|">="|">"|"<"|"="      { printf("OPERATOR\t%s\n", yytext); }
"+"|"-"|"*"|"/"|"%"                   { printf("ARITH_OP\t%s\n", yytext); }
"(" | ")" | "{" | "}" | ";" | ","     { printf("PUNCT\t%s\n", yytext); }
[_A-Za-z][_A-Za-z0-9]*                { printf("IDENTIFIER\t%s\n", yytext); add_id(yytext); }
.                                     { printf("UNKNOWN\t%s\n", yytext); }

%%

int yywrap(){ print_symtab(); return 1; }
int main(int argc,char**argv){ memset(symtab,0,sizeof(symtab)); yylex(); return 0; }
