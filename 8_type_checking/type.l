%{
#include "type.tab.h"
%}
%%
[ \t\r\n]+                { /* skip */ }
"int"                    { return INT; }
"float"                  { return FLOAT; }
[A-Za-z_][A-Za-z0-9_]*   { yylval.id = strdup(yytext); return ID; }
[0-9]+\.[0-9]+           { yylval.fval = atof(yytext); return FLOAT_CONST; }
[0-9]+                   { yylval.ival = atoi(yytext); return INT_CONST; }
"="                      { return '='; }
";"                      { return ';'; }
"+"|"-"|"*"|"/"          { return yytext[0]; }
.                        { return yytext[0]; }
%%
int yywrap(){ return 1; }
