%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap
%%

"main()" {return tMAIN ;}
"{" {return tOPEN_BRKT ;}
"}" {return tCLOSE_BRKT ;}
"const" {return tCONST ;}
"int" {return tINT;}
"+" {return tADD;}
"-" {return tSUB;}
"*" {return tMUL;}
"/" {return tDIV;}
"=" {return tEQL;}
"(" {return tOPEN_PAR;}
")" {return tCLOSE_PAR;}
[ \t]+ {;}
"," {return tCOMMA;}
"\n" {;}
";" {return tSEMICOLON;}
"printf" {return tPRINTF;}

[0-9]+([e][0-9]+)? {
    yylval.nb = (int)strtold(yytext,NULL);
    return tNUM;}

[a-zA-Z][a-zA-Z0-9\_]* {
    yylval.var=malloc(yyleng);
    strcpy(yylval.var,yytext);
    return tVARIABLE;}

%%
   /*int main(){
        yylex();
        return 1;
    }*/