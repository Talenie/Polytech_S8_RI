#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "rdjpeg.h"
#include "proc.h"

#define NBIN 4
#define NCELL 64
#define NVAL 256
#define NCLUSTER 256


/**
 * Créer tout les histogrammes des fichiers donnée dans file et les écris au format binaire dans le fichier sortie
 * ---------------------------
 * Paramètres
 * ---------------------------
 * files : le chemin du fichier ayant les noms de toutes les images à traiter
 * file_out : le nom du fichier de sortie (en binaire) contenant tout les histogrammes crées
 */
void create_all(char *files, char* file_out);

/**
 * Créer tout les histogrammes des fichiers donnée dans file et les écris au format binaire dans le fichier sortie
 * ---------------------------
 * Paramètres
 * ---------------------------
 * files : le chemin du fichier ayant les noms de toutes les images à traiter
 * file_out : le nom du fichier de sortie (en binaire) contenant tout les histogrammes crées
 */
void create_all_clusters(char *files, char* file_out);

/**
 * Crée l'histogramme de taille NBIN^3 correspondant à l'image donnée en entrée
 * ---------------------------
 * Paramètres
 * ---------------------------
 * file : le chemin de l'image à traiter
 */
float* create_histo(char *file);

float* create_histo_cluster(char *file);

/**
 * Retourne la distance euclidienne entre deux vecteurs
 * ---------------------------
 * Paramètres
 * ---------------------------
 * a, b : les deux vecteurs
 * size : la taille des deux vecteurs
 */
float dist(float* a, float*b, int size);

/**
 * Crée la list des scores de chaque images dont l'histogramme est fourni
 * ---------------------------
 * Paramètres
 * ---------------------------
 * file : le nom de l'image en entrée
 * allfiles : le fichier contenant tout les chemins d'images references
 * histogrammes : le fichier binaire contenant tout les histogrammes des images references
 */
KEY* create_keys(char* file, char* allfiles, char* histogrammes);

void sort_keys(KEY* keys, int size);

void show_histo(float *hist, int size);
void show_histo_w(float *hist);
