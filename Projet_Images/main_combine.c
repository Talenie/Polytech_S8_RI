#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "histogrammes.h"

int main(int argc, char *argv[]){
	if(argc < 4){
		printf("Format de commande : \n");
		printf("main_combine <image.jpg> <image.sift> <fichier_sortie>\n");
		exit(1);
	}
	
	int nbdocs, nbdocs2;
	char** index = readList("paths_sift.txt", &nbdocs);
	char** images = readList("urls.txt", &nbdocs2);
	
	KEY* keys_color = create_keys(argv[1],"urls.txt","histos.bin"); 
	KEY* keys_cluster = create_keys_cluster(argv[2],"paths_sift.txt","clusters.bin");
	KEY* keys_combine = combine_keys(keys_color, keys_cluster, nbdocs, 0.85, 0.15);
	sort_keys(keys_combine,nbdocs);
	
	FILE *out = fopen(argv[3],"w");
	if(out == NULL){
		printf("Erreur de création de %s\n", argv[2]);
		exit(2);
	}
	
	fprintf(out,"<h1>Image requete<h1>\n<img src=\"%s\" style=\"max-width : 500px\">\n<h2>10 premiers Resultats<h2>",argv[1]);
	for(int i = 0; i < 10; i++){
		fprintf(out,"<p>Key : %d; Score : %f; Name : %s\n</p>",keys_combine[i].k, keys_combine[i].d,index[keys_combine[i].k]);
		fprintf(out,"<img src=\"%s\" style=\"max-width : 500px\">\n",images[keys_combine[i].k]);
	}
	
	fclose(out);
	
}
