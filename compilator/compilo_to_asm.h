#ifndef compilo_to_asm_h
#define compilo_to_asm_h

#include "list.h"
#include <stdlib.h>
#include <stdio.h>


struct pair{
    int from;
    int to;
    int else_to;
    //1 for simple if, 2 for if else 
    int type;
};


//called at the start of the compiler, opens the file
void init();

//called at the end of the compiler, opens the file
void close();

//print the if 
int print_JMF(char* nom);

//set the 'to' part of the patch nb nb_if
int if_toPatch(int nb_if);
void else_toPatch(int nb_if1, int nb_if2,int try_me);

int save_while();
int print_while(char* nom);
void while_toPatch(int nb_if, int line);

//patch for the if
void patch();

char* printInf(char *name1, char *name2);
char* printSup(char *name1, char *name2);
char* printEql(char *name1, char *name2);

void printIt(char* name);

void DeclConst(char *name1, char *name2);
void checkDefInt(char *name);
void DeclInt(char *name1, char *name2);
void DeclInt(char *name1, char *name2);
void DefInt(char *name1, char *name2);

char* multiply(char *name1, char *name2);
char* divide(char *name1, char *name2);
char* soustract(char *name1, char *name2);
char* add(char *name1, char *name2);

void testVar(char *name);
char *affectation(int val);

#endif
