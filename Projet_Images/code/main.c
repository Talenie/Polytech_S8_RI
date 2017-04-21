#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "histogrammes.h"


int main(int argc, char *argv[]){
	if(argc < 2){
		printf("Veuillez donner :\nLe nom de fichier à comparer\nLe nom de fichier en sortie\n");
		exit(1);
	}
	//create_all(argv[1],argv[2]);
	KEY* keys = create_keys(argv[1],"urls.txt","histos.bin"); 
	sort_keys(keys,9637);
	
	FILE *out = fopen(argv[2],"w");
	if(out == NULL){
		printf("Erreur de création de %s\n", argv[2]);
		exit(2);
	}
	
	fprintf(out,"<h1>Image requete<h1>\n<img src=\"%s\" style=\"max-width : 500px\">\n<h2>10 premiers Resultats<h2>",argv[1]);
	int nbdocs;
	char** index = readList("urls.txt", &nbdocs);
	for(int i = 0; i < 10; i++){
		fprintf("<p>Key : %d; Score : %f; Name : %s\n</p>",keys[i].k, keys[i].d,index[keys[i].k]);
		fprintf(out,"<img src=\"%s\" style=\"max-width : 500px\">\n",index[keys[i].k]);
	}
	exit(0);
}
