%{
#include "calc.tab.h"
%}
%%
[ \t\r\n]+              { /* skip */ }
[0-9]+\.[0-9]+          { yylval.d = atof(yytext); return NUM; }
[0-9]+                  { yylval.d = atof(yytext); return NUM; }
"("                     { return '('; }
")"                     { return ')'; }
"+"|"-"|"*"|"/"         { return yytext[0]; }
\n                      { return EOL; }
.                       { return yytext[0]; }
%%
int yywrap(){ return 1; }
