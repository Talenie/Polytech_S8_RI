#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>


#include "histogrammes.h"


int main(int argc, char *argv[])
{
  int i,j;
  CIMAGE cim;
  
  if(argc < 2){
	  printf("Donner url image\n");
	  exit(1);
  }
  /*------------------------------------------------*/
  /* lecture d'une image requ�te                    */
  /*------------------------------------------------*/
  read_cimage(argv[1],&cim);
  /*------------------------------------------------*/
  /* affichage des valeurs pour le premier bloc 8x8 */
  /* comme exemple de traitement                    */
  /*------------------------------------------------*/
  printf("Largeur de l'image : %d\n",cim.nx);
  printf("Heuteur de l'image : %d\n",cim.ny);
  printf("Plan rouge du premier bloc 8x8 :\n");
  for (j = 0; j < 8; j++) {       /* ligne par ligne */
    printf("  ");
    for (i = 0; i < 8; i++) {   /* pixel par pixel */
      printf("%4d",cim.r[i][j]);
    }
    printf("\n");
  }
  printf("Plan vert du premier bloc 8x8 :\n");
  for (j = 0; j < 8; j++) {       /* ligne par ligne */
    printf("  ");
    for (i = 0; i < 8; i++) {   /* pixel par pixel */
      printf("%4d",cim.g[i][j]);
    }
    printf("\n");
  }
  printf("Plan bleu du premier bloc 8x8 :\n");
  for (j = 0; j < 8; j++) {       /* ligne par ligne */
    printf("  ");
    for (i = 0; i < 8; i++) {   /* pixel par pixel */
      printf("%4d",cim.b[i][j]);
    }
    printf("\n");
  }
  /*------------------------------------------------*/
	
	float* hist = create_histo(argv[1]);

	show_histo(hist,NCELL);

  exit(0);
}
