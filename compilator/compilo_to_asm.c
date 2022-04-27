#include "compilo_to_asm.h"
#include "list.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TAILLE_MAX_INT 10
#define MAX_NB_JUMP 200
#define SIZE_OF_LLINE 512
// table des signes
struct List notre_list;
// fichier de sortie en assembleur
FILE* fichier_tot = NULL;


//nommbre de variablees temporaires utilisées actuellemenet
int nbrVarTemp=0;
//nombre de lignes en assembleur
int nbr_lignes = 0;

//save of the patches
struct pair labels[MAX_NB_JUMP];
int nbr_ifs=0;

int supprline = 0;


int addTmp(){
     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    nbrVarTemp++;
    sprintf(nom, "%dTemp", nbrVarTemp);
    insert(&notre_list,nom,3);
    return notre_list.addr_max - 1;
}

int get_address(char *name){
    int address,test;
    if((test = inlist(notre_list,name,&address)) == 0){      
        printf("Not supposed to happen %s\n",name);
    }else if(test == 3){
        //remove tmp from list
        supprlast(&notre_list);
        nbrVarTemp--;
    }
    return address;
}

//called at the start of the compiler, opens the file
void init(){
    fichier_tot = fopen("compilateur_asm.txt", "w");
    notre_list.addr_max= 0;
}

//called at the end of the compiler, opens the file
void close(){
    fclose(fichier_tot);
}

//print the if 
int print_JMF(char* nom){

    int adressoperand= get_address(nom);

    //add the line later 
    //save current line where to print later
    nbr_lignes++;
    fprintf(fichier_tot,"JMF %d \n",adressoperand);

    if(nbr_ifs<MAX_NB_JUMP){

        labels[nbr_ifs].from= nbr_lignes;
        nbr_ifs++;
        return nbr_ifs-1;

    }
    return -1;
}

int if_toPatch(int nb_if){

    nbr_lignes++;
    fprintf(fichier_tot,"JMP \n");
    labels[nb_if].to = nbr_lignes + 1;

    if(nbr_ifs<MAX_NB_JUMP){
        labels[nbr_ifs].from = nbr_lignes;
        nbr_ifs++;
        return nbr_ifs-1;
    }
    return -1;
}

void else_toPatch(int nb_if1, int nb_if2,int try_me){
    if(try_me == 1){
        labels[nb_if2].to = nbr_lignes + 1;
        labels[nb_if2].type = 1;
    }else{
        labels[nb_if2].type = 2;   
        labels[nb_if1].to--;
    }
    labels[nb_if1].type = 1;
}

int save_while(){
    return nbr_lignes+1;
}

int print_while(char* nom){
    int adressoperand= get_address(nom);
    //add the line later 
    //save current line where to print later
    nbr_lignes++;
    fprintf(fichier_tot,"JMF %d \n",adressoperand);
    if(nbr_ifs<MAX_NB_JUMP){
        labels[nbr_ifs].from= nbr_lignes;
        nbr_ifs++;
        return nbr_ifs-1;
    }
    return -1;
}

void while_toPatch(int nb_if, int line){
    nbr_lignes++;
    fprintf(fichier_tot,"JMP %d\n",line);
    labels[nb_if].to = nbr_lignes + 1;
    labels[nb_if].type = 1;

}

void patch(){
    //
    if(nbr_ifs > 0){
        fclose(fichier_tot);
        rename("compilateur_asm.txt", "tmp.txt");
        fichier_tot = fopen("compilateur_asm.txt", "w");
        FILE *fichier_tmp = fopen("tmp.txt", "r");
        int line = 0;
        char read_line[SIZE_OF_LLINE]; 
        char write_line[SIZE_OF_LLINE+4]; 

        for(int i = 0; i < nbr_ifs ; i++){
            while(line < labels[i].from - 1){
                fgets( read_line, sizeof read_line, fichier_tmp);
                strcpy(write_line, read_line);
                fprintf(fichier_tot , write_line);
                line++;
            }

            printf("type : %d\n",labels[i].type);
            if(labels[i].type == 1){
                //just if 
                fgets( read_line, sizeof read_line, fichier_tmp);
                int backn = '\n';
                char* sindex = strchr(read_line, backn);
                *sindex = '\0';
                sprintf(write_line,"%s%d\n",read_line,labels[i].to-supprline);
                fprintf (fichier_tot , write_line);
                line++;
            }else if(labels[i].type == 2){
                //if else
                fgets( read_line, sizeof read_line, fichier_tmp);
                supprline++;
                line++;
            }
            printf(read_line);
            printf("\n");


        }

        while ( fgets( read_line, sizeof read_line, fichier_tmp) != NULL ){
            strcpy(write_line, read_line);
            fprintf (fichier_tot , write_line);
        }
        remove("tmp.txt");
        
    }
}



char* printInf(char *name1, char *name2){
    int adressoperand1,adressoperand2,adress_result;
    adressoperand2 = get_address(name2);
    adressoperand1 = get_address(name1);

    //add tmp to list
    adress_result= addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"INF %d %d %d\n",adress_result, adressoperand1, adressoperand2);

     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}

char* printSup(char *name1, char *name2){
    int adressoperand1,adressoperand2,adress_result;
    adressoperand2 = get_address(name2);
    adressoperand1 = get_address(name1);

    //add tmp to list
    adress_result= addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"SUP %d %d %d\n",adress_result, adressoperand1, adressoperand2);

     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}

char* printEql(char *name1, char *name2){
    int adressoperand1,adressoperand2,adress_result;
    adressoperand2 = get_address(name2);
    adressoperand1 = get_address(name1);

    //add tmp to list
    adress_result= addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"EQU %d %d %d\n",adress_result, adressoperand1, adressoperand2);

     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}

void printIt(char *name){
    int test,adress;
    if((test = inlist(notre_list,name,&adress)) == 0){      
        printf("Variable does not exist\n");
    }
    nbr_lignes++;
    fprintf(fichier_tot,"PRI %d\n", adress);
}

void DeclConst(char *name1, char *name2){
    int test,adress,adressoperand;
    adressoperand = get_address(name2);
    if((test = inlist(notre_list,name1,&adress)) == 0){      
        insert(&notre_list,name1,2);
        // insert in the list with adress being the max adress
    }else{
        printf("Const aleardy declared\n");
        //throw
    } 
    adress = notre_list.addr_max - 1;

    if(adress != adressoperand){
        nbr_lignes++;
        fprintf(fichier_tot,"COP %d %d\n", adress, adressoperand);
    }
    
}

void checkDefInt(char *name){
    //TEST SI VARIABLE DECLAREE
    int adress;
    if(inlist(notre_list,name,&adress) == 0){      
        insert(&notre_list,name,4);
    }else{
        printf("already declared\n");
    }
}


void DeclInt(char *name1, char *name2){
    int adress,adressoperand;
    adressoperand = get_address(name2);
    
    if(inlist(notre_list,name1,&adress) == 0){      
        insert(&notre_list,name1,1);
        adress = notre_list.addr_max - 1;
    }else{
        printf("already declared\n");
    }
    if(adress != adressoperand){
        nbr_lignes++;
        fprintf(fichier_tot,"COP %d %d\n", adress, adressoperand);
    }
}


 //TEST SI VARIABLE DECLAREE
void DefInt(char *name1, char *name2){
    int adress,adressoperand,test;
    adressoperand = get_address(name2);

    if((test = inlist(notre_list,name1,&adress)) == 0){      
        // errore not supposed to happen
        printf("Not declared int\n");
    }else if(test == 2){
        // errore not supposed to happen
        printf("Variable declared as const, cannot be changed\n");
    }else if(test == 1 || test == 4){
        if(adress != adressoperand){
        nbr_lignes++;
        fprintf(fichier_tot,"COP %d %d\n", adress, adressoperand);
        }
    }else{
        printf("WHUUUUUUT\n");
    }
}

char* multiply(char *name1, char *name2){
    int adressoperand1,adressoperand2,adress_result;
    adressoperand2 = get_address(name2);
    adressoperand1 = get_address(name1);

    adress_result= addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"MUL %d %d %d\n",adress_result, adressoperand1, adressoperand2);

     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}

char* divide(char *name1, char *name2){
    int adressoperand1,adressoperand2,adress_result;
    adressoperand2 = get_address(name2);
    adressoperand1 = get_address(name1);

    adress_result= addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"DIV %d %d %d\n",adress_result, adressoperand1, adressoperand2);

     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}

char* soustract(char *name1, char *name2){
    int adressoperand1,adressoperand2,adress_result;
    adressoperand2 = get_address(name2);
    adressoperand1 = get_address(name1);

    adress_result= addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"SOU %d %d %d\n",adress_result, adressoperand1, adressoperand2);
    
     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}

char* add(char *name1, char *name2){
    int adressoperand1,adressoperand2,adress_result;
    adressoperand2 = get_address(name2);
    adressoperand1 = get_address(name1);

    adress_result= addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"ADD %d %d %d\n",adress_result, adressoperand1, adressoperand2);
    
     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}

void testVar(char *name){
    int adress,test; 
    if((test = inlist(notre_list,name,&adress)) == 0){      
        printf("Not declared variable\n");
    }else if(test == 4){
        printf("Integer not instanciated\n");
    }
}

char *affectation(int val){
    int adress= addTmp();
    nbr_lignes++;
    fprintf(fichier_tot,"AFC %d %d\n",adress, val);

    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbrVarTemp);
    return nom;
}