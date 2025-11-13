%{
#include <stdio.h>
%}
%%
"/*"([^*]|\*+[^*/])*\*+ "/"          { /* skip comments */ }
"//".*                              { /* skip */ }
[ \t\r\n]+                          { /* skip */ }
"int"|"float"|"char"|"double"|"return"|"if"|"else"|"for"|"while"   { printf("%-15s : KEYWORD\n", yytext); }
[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?  { printf("%-15s : CONSTANT\n", yytext); }
\"([^\\\"]|\\.)*\"                   { printf("%-15s : STRING_LITERAL\n", yytext); }
"=="|"!="|"<="|">="|">"|"<"|"="      { printf("%-15s : OPERATOR\n", yytext); }
"+"|"-"|"*"|"/"|"%"                   { printf("%-15s : ARITH_OP\n", yytext); }
"(" | ")" | "{" | "}" | ";" | ","     { printf("%-15s : PUNCTUATION\n", yytext); }
[_A-Za-z][_A-Za-z0-9]*                { printf("%-15s : IDENTIFIER\n", yytext); }
.                                     { printf("%-15s : UNKNOWN\n", yytext); }
%%
int yywrap(){ return 1; }
int main(){ yylex(); return 0; }
