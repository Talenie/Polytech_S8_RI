#include "histogrammes.h"

void create_all(char *directory){
	/* Directory est le répértoire contenant toutes les images à traiter */
	
}

float* create_histo(char *file){
	CIMAGE image;
	read_cimage(file,&image);
	
	float *hist = (float*) malloc(sizeof(float)*NCELL);
	for (int i = 0; i < NCELL; i++){
		hist[i] = 0;	
	}
	
	for( int x = 0; x < image.nx; x++) {
		for (int y = 0; y < image.ny; y++){
			int r,g,b;
			r = floor(image.r[x][y]/(NVAL/NBIN));
			g = floor(image.g[x][y]/(NVAL/NBIN));
			b = floor(image.b[x][y]/(NVAL/NBIN));
			hist[ r*NBIN*NBIN + g * NBIN + b]++;
		}
	}
	return hist;	
}
