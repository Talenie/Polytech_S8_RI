#include "histogrammes.h"

/**
 * Créer tout les historammes et les écris au format binaire dans le fichier "histos.bin"
 */
void create_all(char *file){
	/* file est le fichier contenant toutes les urls d'images à traiter */
	FILE *f = fopen(file,"r");
	if(f==NULL){
		printf("Histogrammes.create_all : Could not open %s\n",file);
		exit(1);
	}
	char url[256];
	float *hist;
	FILE *out = fopen("histos.bin","w");
	if(f==NULL){
		printf("Histogrammes.create_all : Could not create histos.bin\n");
		exit(2);
	}
	
	while(!feof(f)){
		fscanf(f,"%s",url);
		printf("Creating histogram for %s\n",url);
		hist = create_histo(url);
		fwrite(hist, sizeof(float), (size_t)NCELL, out);		
	}	
	fclose(out);
	fclose(f);
}




float* create_histo(char *file){
	CIMAGE image;
	read_cimage(file,&image);
	
	float *hist = (float*) malloc(sizeof(float)*NCELL);
	for (int i = 0; i < NCELL; i++){
		hist[i] = 0.0;	
	}
	
	for( int x = 0; x < image.nx; x++) {
		for (int y = 0; y < image.ny; y++){
			int r,g,b;
			r = ((int)image.r[x][y])/(NVAL/NBIN);
			g = ((int)image.g[x][y])/(NVAL/NBIN);
			b = ((int)image.b[x][y])/(NVAL/NBIN);
			hist[r*NBIN*NBIN + g * NBIN + b]++;
		}
	}
	
	/* Normalisation de l'histogramme */
	for (int i = 0; i < NCELL; i++){
		hist[i] /= (float)(image.nx*image.ny);	
	}
	
	return hist;	
}

float dist(float* a, float*b, int size){
	float res = 0.0;
	for(int i = 0; i < size; i++){
		res += (a[i]-b[i])*(a[i]-b[i]);
	}
	return res;
}


KEY* create_keys(char* file, char* histogrammes){
	float* req = create_histo(file);
	int taille,nbdocs;
	char** index = readList("urls.txt", &nbdocs);
	
	KEY* scores = (KEY*) malloc(sizeof(KEY)*nbdocs);
	
	float **hists = readDescriptors(histogrammes, nbdocs, &taille);
	
	for( int i = 0; i < nbdocs; i++){
		KEY key;
		key.k = i;
		key.d = dist(req,hists[i],taille);
		scores[i] = key;
	}
	
	return scores;	
}


void show_histo(float *hist) {
	printf("Contenu histogramme\n");
	printf("BIN	val\n");
	float sum = 0.0;
	
	for(int x = 0; x < NCELL; x++){
		printf("%3d %.*s\n", x, (int)(hist[x]*1000), "███████████████████████████████████████████████████████████████████████");
		sum += hist[x];
	}
	
	printf("Sum : %f\nNBIN : %d\n",sum,NBIN);
}

void show_histo_w(float *hist) {
	printf("Contenu histogramme\n");
	printf("BIN	val\n");
	float sum = 0.0;
	
	for(int x = 0; x < NCELL; x++){
		//printf("%3d : %f\n",x,hist[x]);
		sum += hist[x];
	}
	
	printf("Sum : %f\nNBIN : %d\n",sum,NBIN);
}
