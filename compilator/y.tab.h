/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tMAIN = 258,
    tOPEN_BRKT = 259,
    tCLOSE_BRKT = 260,
    tCONST = 261,
    tADD = 262,
    tSUB = 263,
    tMUL = 264,
    tDIV = 265,
    tEQL = 266,
    tOPEN_PAR = 267,
    tCLOSE_PAR = 268,
    tCOMMA = 269,
    tSEMICOLON = 270,
    tPRINTF = 271,
    tINT = 272,
    tELSE = 273,
    tINF = 274,
    tSUP = 275,
    tRETURN = 276,
    tNUM = 277,
    tIF = 278,
    tWHILE = 279,
    tNAME = 280
  };
#endif
/* Tokens.  */
#define tMAIN 258
#define tOPEN_BRKT 259
#define tCLOSE_BRKT 260
#define tCONST 261
#define tADD 262
#define tSUB 263
#define tMUL 264
#define tDIV 265
#define tEQL 266
#define tOPEN_PAR 267
#define tCLOSE_PAR 268
#define tCOMMA 269
#define tSEMICOLON 270
#define tPRINTF 271
#define tINT 272
#define tELSE 273
#define tINF 274
#define tSUP 275
#define tRETURN 276
#define tNUM 277
#define tIF 278
#define tWHILE 279
#define tNAME 280

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 13 "compilo.y"
 int nb ; char *name; struct fak *two;

#line 110 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
