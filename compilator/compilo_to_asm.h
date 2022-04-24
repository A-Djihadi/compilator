#ifndef compilo_to_asm
#define compilo_to_asm

#include "list.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


#define TAILLE_MAX_INT 10
#define MAX_IF_INSIDE 10

struct pair{
    int from;
    int to;
};



int get_address(char *nom);

//called at the start of the compiler, opens the file
void init();

//called at the end of the compiler, opens the file
void close();

//print the if 
int print_JMF(char* nom);
void to_patch(int from,int to);
void patch();

char* printInf(char *name1, char *name2);
char* printSup(char *name1, char *name2);
char* printEql(char *name1, char *name2);
void printIt(char* name);

void DeclConst(char *name1, char *name2);
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
