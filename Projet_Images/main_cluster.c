#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "histogrammes.h"

int main(int argc, char *argv[]){
	/*
	loat *hist = create_histo_cluster("sift/test/1nn/2008_003206.sift");
	printf("Coucou\n");
	show_histo(hist,NCLUSTER);
	* */
	//create_all_clusters("paths_sift.txt","clusters.bin");
	
	if(argc < 3){
		printf("Donner le nom de fichier sift a comparer et le nom du HTML de sortie\n");
		exit(1);
	}	
	
	int nbdocs,nbdocs2;
	KEY* keys = create_keys_cluster(argv[1],"paths_sift.txt","clusters.bin"); 
	char** index = readList("paths_sift.txt", &nbdocs);
	char** images = readList("urls.txt", &nbdocs2);
	sort_keys(keys,nbdocs);
	
	FILE *out = fopen(argv[2],"w");
	if(out == NULL){
		printf("Erreur de création de %s\n", argv[2]);
		exit(2);
	}
	
	fprintf(out,"<h1>Image requete<h1>\n<img src=\"%s\" style=\"max-width : 500px\">\n<h2>10 premiers Resultats<h2>",argv[1]);
	for(int i = 0; i < 10; i++){
		fprintf(out,"<p>Key : %d; Score : %f; Name : %s\n</p>",keys[i].k, keys[i].d,index[keys[i].k]);
		fprintf(out,"<img src=\"%s\" style=\"max-width : 500px\">\n",images[keys[i].k]);
	}
	
	fclose(out);
	
	exit(0);
}

