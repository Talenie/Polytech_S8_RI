

all : read_image

read_image :  rdjpeg.o read_image.o histogrammes.o
	gcc rdjpeg.o read_image.o histogrammes.o -o read_image -lm

rdjpeg.o : rdjpeg.c rdjpeg.h
	gcc -o rdjpeg.o -c rdjpeg.c -Wall


read_image.o : read_image.c
	gcc -o read_image.o -c read_image.c -Wall


histogrammes.o : histogrammes.c histogrammes.h
	gcc -o histogrammes.o -c histogrammes.c -Wall -lm
