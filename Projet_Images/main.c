#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "histogrammes.h"


int main(int argc, char *argv[]){
	if(argc < 2){
		printf("Veuillez rentrer le fichier contenant les chemins d'images dont on doit créer les histogrammes en entrée\n");
		exit(1);
	}
	create_all(argv[1]);
	exit(0);
}
