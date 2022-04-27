%{
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap
%%
 
"main()" {printf("tMAIN \n");}
"{" {printf("tOPEN_BRKT \n");}
"}" {printf("tCLOSE_BRKT \n");}}
"const" {printf("tCONST \n");}
"int" {printf("tINT\n");}
"+" {printf("tADD\n");}
"-" {printf("tSUB\n");}
"*" {printf("tMUL\n");}
"/" {printf("tDIV\n");}
"=" {printf("tEQL\n");}
"<" {printf("tINF\n");}
">" {printf("tSUP\n");}
"(" {printf("tOPEN_PAR\n");}
")" {printf("tCLOSE_PAR\n");}
[ \t]+ {printf("tSPACE\n");}
"," {printf("tCOMMA\n");}
"\n"+ {printf("tENDL\n");}
";" {printf("tSEMICOLON\n");}
"printf" {printf("tPRINTF\n");}

[0-9]+([e][0-9]+)? {printf("tNUM %s \n",yytext);}

[a-zA-Z][a-zA-Z0-9\_]* {printf("mot trouvé %s \n",yytext);}



%%
   int main(){
        yylex();
        return 1;
    }