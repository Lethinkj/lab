%{
#include "expr.tab.h"
%}
%%
[ \t\r\n]+            { /* skip */ }
[0-9]+                { yylval.num = atoi(yytext); return NUM; }
"("                   { return '('; }
")"                   { return ')'; }
"+"|"-"|"*"|"/"       { return yytext[0]; }
.                     { return yytext[0]; }
%%
int yywrap(){return 1;}
