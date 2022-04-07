%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap
%%

"main()" {return tMAIN ;}
"if" {return tIF ;}
"ELSE" {return tELSE ;}
"while" {return tWHILE ;}
"const" {return tCONST ;}
"int" {return tINT;}
"printf" {return tPRINTF;}
"{" {return tOPEN_BRKT ;}
"}" {return tCLOSE_BRKT ;}
"(" {return tOPEN_PAR;}
")" {return tCLOSE_PAR;}
"+" {return tADD;}
"-" {return tSUB;}
"*" {return tMUL;}
"/" {return tDIV;}
"=" {return tEQL;}
"," {return tCOMMA;}
"\n" {;}
";" {return tSEMICOLON;}
[ \t]+ {;}

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