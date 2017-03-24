#include "histogrammes.h"

void create_all(char *directory){
	/* Directory est le répértoire contenant toutes les images à traiter */
	
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
			hist[ r*NBIN*NBIN + g * NBIN + b]++;
		}
	}
	
	/* Normalisation de l'histogramme */
	for (int i = 0; i < NCELL; i++){
		hist[i] /= (float)(image.nx*image.ny);	
	}
	
	return hist;	
}
