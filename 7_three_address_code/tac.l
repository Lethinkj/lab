%{
#include "tac.tab.h"
%}
%%
[ \t\r\n]+              { /* skip */ }
[0-9]+                  { yylval.num = atoi(yytext); return NUM; }
[A-Za-z_][A-Za-z0-9_]*  { yylval.id = strdup(yytext); return ID; }
"="                     { return '='; }
";"                     { return ';'; }
"+"|"-"|"*"|"/"         { return yytext[0]; }
"("                     { return '('; }
")"                     { return ')'; }
.                       { return yytext[0]; }
%%
int yywrap(){ return 1; }
