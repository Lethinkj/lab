%{
#include "idcheck.tab.h"
%}
%%
[ \t\r\n]+              { /* skip */ }
[A-Za-z][A-Za-z0-9]*    { yylval.str = strdup(yytext); return ID; }
.                       { return yytext[0]; }
%%
int yywrap(){return 1;}
