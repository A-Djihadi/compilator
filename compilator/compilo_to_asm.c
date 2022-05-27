#include "compilo_to_asm.h"
#include "list.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TAILLE_MAX_INT 10
#define MAX_NB_JUMP 200
#define SIZE_OF_LLINE 512
#define SIZE_FONCTION_NAME 256
#define MAX_NUMBER_OF_FUNCTIONS 5
// table des signes
struct List notre_list;
// fichier de sortie en assembleur
FILE* fichier_tot = NULL;


//sprintf(namefile,"%s.txt",name);
char functions[MAX_NUMBER_OF_FUNCTIONS][SIZE_FONCTION_NAME];
int param_functions[MAX_NUMBER_OF_FUNCTIONS];

int nbr_functions = 0;
int nbr_Params=0;

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

void init_fct(char *name){
    nbr_Params=0;
    char* namefile = malloc(SIZE_FONCTION_NAME);
    sprintf(namefile,"%s.txt",name);
    strcpy( functions[nbr_functions], name);
    nbr_Params = 0;
    fichier_tot = fopen(namefile, "w");
}

void close_fct(){
    param_functions[nbr_functions]=nbr_Params;
    clearlist(&notre_list);
    nbrVarTemp = 0;
    close(functions[nbr_functions]);
    nbr_functions++;
}

void addIntParam(char *name1){
    int adress;
    if(inlist(notre_list,name1,&adress) == 0){      
        insert(&notre_list,name1,1);
        nbr_Params++;
    }else{
        printf("Should not happen\n");
    }
}

void addConstParam(char *name1){
    int adress;
    if(inlist(notre_list,name1,&adress) == 0){      
        insert(&notre_list,name1,2);
        nbr_Params++;
    }else{
        printf("Should not happen\n");
    }
}



//called at the start of the compiler, opens the file
void init(){
    nbr_lignes = 0;
    nbr_ifs = 0;
    
    fichier_tot = fopen("compilateur_asm.txt", "w");
    notre_list.addr_max= 0;
}

//called at the end of the compiler, opens the file
void close(){
    print_list(&notre_list);
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

void patch(char* name_file){
    //
    if(nbr_ifs > 0){
        fclose(fichier_tot);

        rename(name_file, "tmp.txt");
        fichier_tot = fopen(name_file, "w");
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
            //printf("type : %d\n",labels[i].type);
            if(labels[i].type == 1){
                //just if 
                fgets( read_line, sizeof read_line, fichier_tmp);
                int backn = '\n';
            // printf("value i : %d\n",i);
                char* sindex = strchr(read_line, backn);
            // printf("valu line pour voir  : %d\n",line);
            // printf(sindex);
            // printf("fak i : %d\n",i);

                *sindex = '\0';

                sprintf(write_line,"%s%d\n",read_line,labels[i].to-supprline);
            // printf("value i : %d\n",i);
                fprintf (fichier_tot , write_line);
                line++;
            }else if(labels[i].type == 2){
                //if else
                fgets( read_line, sizeof read_line, fichier_tmp);
                supprline++;
                line++;
            }
            // printf(read_line);
            printf("A jmp \n");


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
    print_list(&notre_list);
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

int init_call_fct(){
    nbr_Params = 0;
}

void param_fct(char *name){
    int adress = get_address(name);
    int adress2 = addTmp();

    nbr_lignes++;
    fprintf(fichier_tot,"COP %d %d\n",adress2, adress);
    nbr_Params++;
}

char * check_fct_call(char *name){ 
    int i = -1;
    int test = 1;
    while(test != 0 && i < nbr_functions){
        //compare name fct
         i++;
         test = strcmp(functions[i],name);
    }
    if(i == nbr_functions && !strcmp(functions[i],name) ){
        printf("Funtion does not exist\n");
    }else if(nbr_Params != param_functions[i]){
        printf("Incorect number of arguments put %d instead of %d \n",param_functions[i],nbr_Params);
    }else{
        int adress1,adress2,adress3;
        char* full_name = malloc(sizeof(name));  
        sprintf(full_name, "%s.txt", name);
        FILE * function = fopen(full_name, "r");
        char * commande= malloc( 4);
        int save_nb_vars = nbrVarTemp;
        int save_lines = nbr_lignes;

        while(fscanf(function,"%s %d",commande,&adress1)!=EOF){
            
            if(strcmp(commande,"ADD")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"ADD %d %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars,adress3 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"MUL")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"MUL %d %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars,adress3 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"SOU")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"SOU %d %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars,adress3 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"DIV")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"DIV %d %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars,adress3 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"COP")==0){
                fscanf(function,"%d",&adress2);
                fprintf(fichier_tot,"COP %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"AFC")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"AFC %d %d\n",adress1 + save_nb_vars,adress2);
                nbr_lignes++;
            }
            else if(strcmp(commande,"JMP")==0){
                fprintf(fichier_tot,"JMP %d\n",adress1 + save_lines);
                nbr_lignes++;
            }
            else if(strcmp(commande,"JMF")==0){
                fscanf(function,"%d",&adress2);
                fprintf(fichier_tot,"JMF %d %d\n",adress1 + save_nb_vars,adress2 + save_lines);
                nbr_lignes++;
            }
            else if(strcmp(commande,"INF")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"INF %d %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars,adress3 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"SUP")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"SUP %d %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars,adress3 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"EQU")==0){
                fscanf(function,"%d",&adress2);
                fscanf(function,"%d",&adress3);
                fprintf(fichier_tot,"EQU %d %d %d\n",adress1 + save_nb_vars,adress2 + save_nb_vars,adress3 + save_nb_vars);
                nbr_lignes++;
            }
            else if(strcmp(commande,"PRI")==0){
                fprintf(fichier_tot,"PRI %d\n",adress1 + save_nb_vars);
                nbr_lignes++;
            }
        }
    }
    for(int j = 0; j<nbr_Params;j++){
        supprlast(&notre_list);
    }

    addTmp();
    
    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbrVarTemp);
    
    printf(nom);
    print_list(&notre_list);

    return nom;
}

void print_return(char * name){
    int adress, test;
    if((test = inlist(notre_list,name,&adress)) == 0){      
        printf("Not declared variable\n");
    }else if(test == 4){
        printf("Integer not instanciated\n");
    }

    if(adress != 0){
        fprintf(fichier_tot,"COP 0 %d\n", adress);
        printf("adresse du return : %d\n",adress);
    }
}
