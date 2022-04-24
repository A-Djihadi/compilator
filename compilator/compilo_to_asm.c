#include "compilo_to_asm.h"
#include "list.h"

// table des signes
struct List notre_list;
// fichier de sortie en assembleur
FILE* fichier_tot = NULL;

//nommbre de variablees temporaires utilisées actuellemenet
int nbrVarTemp=0;
//nombre de lignes en assembleur
int nbr_lignes = 0;

//save of the patches
struct pair labels[MAX_IF_INSIDE];
int nbr_ifs=0;

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
    return nbr_lignes;
}

void to_patch(int from,int to_plus){
    if(nbr_ifs<MAX_IF_INSIDE){
    labels[nbr_ifs].to = nbr_lignes + to_plus;
    labels[nbr_ifs].from= from;
    nbr_ifs++;
    }
}

void patch(){
    printf("hello world");
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

void fonction1(){
    
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