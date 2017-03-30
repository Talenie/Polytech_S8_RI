#include <stdio.h>
#include <math.h>
#include "rdjpeg.h"
#include "proc.h"

#define NBIN 4
#define NCELL 64
#define NVAL 256

void create_all(char *directory);
float* create_histo(char *file);
void show_histo(float *hist);
void show_histo_w(float *hist);
