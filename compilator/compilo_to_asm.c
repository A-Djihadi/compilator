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

// Table of variables
struct List notre_list;
int nbVarTemp=0;

// for written files
FILE* fichier_tot = NULL;
int nb_ligne = 0;

// for function
char functions[MAX_NUMBER_OF_FUNCTIONS][SIZE_FONCTION_NAME];
int param_functions[MAX_NUMBER_OF_FUNCTIONS];

int nb_functions = 0;
int nb_Params=0;
int nb_Params_call=0;

//for the patches
struct pair labels[MAX_NB_JUMP];
int nb_ifs=0;
int supprline = 0;


int addTmp(){
    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    nbVarTemp++;
    sprintf(nom, "%dTemp", nbVarTemp);
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
        nbVarTemp--;
    }
    return address;
}

void init_fct(char *name){
    // Reset all needed parameters
    nb_Params=0;
    nbVarTemp = 0;
    nb_ligne = 0;
    
    //save the name of the fct
    char* namefile = malloc(SIZE_FONCTION_NAME);
    sprintf(namefile,"%s.txt",name);
    strcpy( functions[nb_functions], name);
    
    fichier_tot = fopen(namefile, "w");
}

void close_fct(){
    //empty the saved variable
    clearlist(&notre_list);
    //save info for later call 
    param_functions[nb_functions]=nb_Params;
    close(functions[nb_functions]);
    nb_functions++;
}

void addIntParam(char *name1){
    int address;
    if(inlist(notre_list,name1,&address) == 0){      
        insert(&notre_list,name1,1);
        nb_Params++;
    }else{
        printf("Should not happen\n");
    }
}

void addConstParam(char *name1){
    int address;
    if(inlist(notre_list,name1,&address) == 0){      
        insert(&notre_list,name1,2);
        nb_Params++;
    }else{
        printf("Should not happen\n");
    }
}

void print_return(char * name){
    int address, test;
    if((test = inlist(notre_list,name,&address)) == 0){      
        printf("Not declared variable\n");
    }else if(test == 4){
        printf("Integer not instanciated\n");
    }

    if(address != 0){
        fprintf(fichier_tot,"COP 0 %d\n", address);
        nb_ligne++;
    }
}



void init(){
    // initializes what is needed for the main function
    nb_ligne = 0;
    nb_ifs = 0;
    nbVarTemp = 0;
    clearlist(&notre_list);
    
    fichier_tot = fopen("code_assembleur.txt", "w");
}

void close(){
    clearlist(&notre_list);

    // remove the files for the functions
    for(int i = 0; i<nb_functions; i++){
        char* name_file=malloc(4 + sizeof(functions[i]));  
        sprintf(name_file, "%s.txt", functions[i]);
        remove(name_file);
        free(name_file);
    }

    fclose(fichier_tot);
}

int print_JMF(char* nom){

    int addressoperand= get_address(nom);

    nb_ligne++;
    fprintf(fichier_tot,"JMF %d \n",addressoperand);

    //save the position of the JMF to modify later on
    if(nb_ifs<MAX_NB_JUMP){
        labels[nb_ifs].from= nb_ligne;
        nb_ifs++;
        return nb_ifs-1;
    }

    printf("Max jump reached\n");
    return -1;
}

int if_toPatch(int nb_if){ 

    nb_ligne++;
    // set the patch for the previous jump
    labels[nb_if].to = nb_ligne + 1;

    fprintf(fichier_tot,"JMP \n");

    //initiate the patch for the actual jump
    if(nb_ifs<MAX_NB_JUMP){
        labels[nb_ifs].from = nb_ligne;
        nb_ifs++;
        return nb_ifs-1;
    }
    return -1;
}

void else_toPatch(int nb_if1, int nb_if2,int try_me){
    //check if the else is used or not and set the patch accordingly 
    if(try_me == 1){
        //else 
        labels[nb_if2].to = nb_ligne + 1;
        labels[nb_if2].type = 1;
    }else{
        //no else
        labels[nb_if2].type = 2;   
        labels[nb_if1].to--;
    }
    labels[nb_if1].type = 1;
}

int save_while(){
    return nb_ligne+1;
}

int print_while(char* nom){
    int addressoperand= get_address(nom);
    nb_ligne++;

    fprintf(fichier_tot,"JMF %d \n",addressoperand);

    //set for patch
    if(nb_ifs<MAX_NB_JUMP){
        labels[nb_ifs].from= nb_ligne;
        nb_ifs++;
        return nb_ifs-1;
    }
    return -1;
}

void while_toPatch(int nb_if, int line){
    nb_ligne++;
    fprintf(fichier_tot,"JMP %d\n",line);
    //set for patch
    labels[nb_if].to = nb_ligne + 1;
    labels[nb_if].type = 1;
}

void patch(char* name){
    //do all modification for the jump
    char* name_file=malloc(4 + sizeof(name));  
    sprintf(name_file, "%s.txt", name);

    if(nb_ifs > 0){
        // to do the patch, we need to copy paste the text file:
        //first we close it and rename and open again the current one   
        fclose(fichier_tot);
        rename(name_file, "tmp.txt");
        FILE *fichier_tmp = fopen("tmp.txt", "r");
        //create the destination file
        fichier_tot = fopen(name_file, "w");

        int line = 0;
        char read_line[SIZE_OF_LLINE]; 
        char write_line[SIZE_OF_LLINE+4]; 

        //loop on all patches (they are in the order)
        for(int i = 0; i < nb_ifs ; i++){
            //go to the line to be patched
            while(line < labels[i].from - 1){
                fgets( read_line, sizeof read_line, fichier_tmp);
                strcpy(write_line, read_line);
                fprintf(fichier_tot , write_line);
                line++;
            }

            //
            if(labels[i].type == 1){
                // add the jump address at the end of the line
                fgets( read_line, sizeof read_line, fichier_tmp);
                int backn = '\n';
                char* sindex = strchr(read_line, backn);
                *sindex = '\0';

                sprintf(write_line,"%s%d\n",read_line,labels[i].to-supprline);
                fprintf (fichier_tot , write_line);
                line++;

            }else if(labels[i].type == 2){
                //when only if, a jump needs to be removed
                fgets( read_line, sizeof read_line, fichier_tmp);
                supprline++;
                line++;
            }
        }

        while ( fgets( read_line, sizeof read_line, fichier_tmp) != NULL ){
            strcpy(write_line, read_line);
            fprintf(fichier_tot , write_line);
            line++;
        }
        remove("tmp.txt");
        
    }
}



char* printInf(char *name1, char *name2){
    int addressoperand1,addressoperand2,address_result;
    addressoperand2 = get_address(name2);
    addressoperand1 = get_address(name1);

    address_result= addTmp();

    fprintf(fichier_tot,"INF %d %d %d\n",address_result, addressoperand1, addressoperand2);
    nb_ligne++;

    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

char* printSup(char *name1, char *name2){
    int addressoperand1,addressoperand2,address_result;
    addressoperand2 = get_address(name2);
    addressoperand1 = get_address(name1);

    address_result= addTmp();

    nb_ligne++;
    fprintf(fichier_tot,"SUP %d %d %d\n",address_result, addressoperand1, addressoperand2);

     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

char* printEql(char *name1, char *name2){
    int addressoperand1,addressoperand2,address_result;
    addressoperand2 = get_address(name2);
    addressoperand1 = get_address(name1);

    address_result= addTmp();

    nb_ligne++;
    fprintf(fichier_tot,"EQU %d %d %d\n",address_result, addressoperand1, addressoperand2);

     char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

void printIt(char *name){
    int test,address;
    if((test = inlist(notre_list,name,&address)) == 0){      
        printf("Variable does not exist\n");
    }
    nb_ligne++;
    fprintf(fichier_tot,"PRI %d\n", address);
}

void DeclConst(char *name1, char *name2){
    int test,address,addressoperand;
    addressoperand = get_address(name2);

    if((test = inlist(notre_list,name1,&address)) == 0){      
        //add to the table
        insert(&notre_list,name1,2);
    }else{
        printf("Const aleardy declared\n");
    } 
    address = notre_list.addr_max - 1;

    //can remove useless COP
    if(address != addressoperand){
        nb_ligne++;
        fprintf(fichier_tot,"COP %d %d\n", address, addressoperand);
    }
    
}

void checkDefInt(char *name){

    int address;
    if(inlist(notre_list,name,&address) == 0){      
        insert(&notre_list,name,4);
    }else{
        printf("already declared\n");
    }
}


void DeclInt(char *name1, char *name2){
    int address,addressoperand;
    addressoperand = get_address(name2);
    
    if(inlist(notre_list,name1,&address) == 0){      
        insert(&notre_list,name1,1);
        address = notre_list.addr_max - 1;
    }else{
        printf("already declared\n");
    }
    if(address != addressoperand){
        nb_ligne++;
        fprintf(fichier_tot,"COP %d %d\n", address, addressoperand);
    }
}



void DefInt(char *name1, char *name2){

    int address,addressoperand,test;
    addressoperand = get_address(name2);

    if((test = inlist(notre_list,name1,&address)) == 0){      
        printf("Not declared int\n");
    }else if(test == 2){
        printf("Variable declared as const, cannot be changed\n");
    }else if(test == 1 || test == 4){
        //TODO: modif pour mettre 4 à la place
        if(address != addressoperand){
        nb_ligne++;
        fprintf(fichier_tot,"COP %d %d\n", address, addressoperand);
        }
    }else{
        printf("WHUUUUUUT\n");
    }
}

char* multiply(char *name1, char *name2){
    int addressoperand1,addressoperand2,address_result;
    addressoperand2 = get_address(name2);
    addressoperand1 = get_address(name1);

    address_result= addTmp();

    nb_ligne++;
    fprintf(fichier_tot,"MUL %d %d %d\n",address_result, addressoperand1, addressoperand2);

    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

char* divide(char *name1, char *name2){
    int addressoperand1,addressoperand2,address_result;
    addressoperand2 = get_address(name2);
    addressoperand1 = get_address(name1);

    address_result= addTmp();

    nb_ligne++;
    fprintf(fichier_tot,"DIV %d %d %d\n",address_result, addressoperand1, addressoperand2);

    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char));  
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

char* soustract(char *name1, char *name2){
    int addressoperand1,addressoperand2,address_result;
    addressoperand2 = get_address(name2);
    addressoperand1 = get_address(name1);

    address_result= addTmp();

    nb_ligne++;
    fprintf(fichier_tot,"SOU %d %d %d\n",address_result, addressoperand1, addressoperand2);
    
    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

char* add(char *name1, char *name2){
    int addressoperand1,addressoperand2,address_result;
    addressoperand2 = get_address(name2);
    addressoperand1 = get_address(name1);

    address_result= addTmp();

    nb_ligne++;
    fprintf(fichier_tot,"ADD %d %d %d\n",address_result, addressoperand1, addressoperand2);
    
    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

void testVar(char *name){
    int address,test; 
    if((test = inlist(notre_list,name,&address)) == 0){      
        printf("Not declared variable\n");
    }else if(test == 4){
        printf("Integer not instanciated\n");
    }
}

char *affectation(int val){
    int address= addTmp();
    nb_ligne++;
    fprintf(fichier_tot,"AFC %d %d\n",address, val);

    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

int init_call_fct(){
    nb_Params_call = 0;
}

void param_fct(char *name){
    int address = get_address(name);
    int address2 = addTmp();

    nb_ligne++;
    fprintf(fichier_tot,"COP %d %d\n",address2, address);
    nb_Params_call++;
}

char * check_fct_call(char *name){ 
    int i = -1;
    int test = 1;
    while(test != 0 && i < nb_functions){
        //find the right fct
        i++;
        test = strcmp(functions[i],name);
    }
    
    if(i == nb_functions && !strcmp(functions[i],name) ){
        printf("Funtion does not exist\n");
    }else if(nb_Params_call != param_functions[i]){
        printf("Incorect number of arguments put %d instead of %d \n",param_functions[i],nb_Params_call);
    }else{
        int address1,address2,address3;
        char* full_name = malloc(sizeof(name));  
        sprintf(full_name, "%s.txt", name);
        FILE * function = fopen(full_name, "r");
        char * commande= malloc( 4);
        int save_nb_vars = nbVarTemp;
        int save_lines = nb_ligne;

        while(fscanf(function,"%s %d",commande,&address1)!=EOF){
            //copy the function code and change the adresses to fit
            if(strcmp(commande,"ADD")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"ADD %d %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars,address3 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"MUL")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"MUL %d %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars,address3 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"SOU")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"SOU %d %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars,address3 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"DIV")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"DIV %d %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars,address3 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"COP")==0){
                fscanf(function,"%d",&address2);
                fprintf(fichier_tot,"COP %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"AFC")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"AFC %d %d\n",address1 + save_nb_vars,address2);
                nb_ligne++;
            }
            else if(strcmp(commande,"JMP")==0){
                fprintf(fichier_tot,"JMP %d\n",address1 + save_lines);
                nb_ligne++;
            }
            else if(strcmp(commande,"JMF")==0){
                fscanf(function,"%d",&address2);
                fprintf(fichier_tot,"JMF %d %d\n",address1 + save_nb_vars,address2 + save_lines);
                nb_ligne++;
            }
            else if(strcmp(commande,"INF")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"INF %d %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars,address3 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"SUP")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"SUP %d %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars,address3 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"EQU")==0){
                fscanf(function,"%d",&address2);
                fscanf(function,"%d",&address3);
                fprintf(fichier_tot,"EQU %d %d %d\n",address1 + save_nb_vars,address2 + save_nb_vars,address3 + save_nb_vars);
                nb_ligne++;
            }
            else if(strcmp(commande,"PRI")==0){
                fprintf(fichier_tot,"PRI %d\n",address1 + save_nb_vars);
                nb_ligne++;
            }
        }
        fclose(function);

    }

    for(int j = 0; j<nb_Params_call;j++){
        supprlast(&notre_list);
    }

    addTmp();

    char* nom=malloc(TAILLE_MAX_INT+4 * sizeof(char)); 
    sprintf(nom, "%dTemp", nbVarTemp);
    return nom;
}

