

all : read_image main

read_image :  rdjpeg.o read_image.o histogrammes.o
	gcc rdjpeg.o read_image.o histogrammes.o -o read_image -lm
	
main : rdjpeg.o main.o histogrammes.o
	gcc rdjpeg.o main.o histogrammes.o -o main
	
main.o : main.c
	gcc -o main.o -c main.c -Wall

rdjpeg.o : rdjpeg.c rdjpeg.h
	gcc -o rdjpeg.o -c rdjpeg.c -Wall


read_image.o : read_image.c
	gcc -o read_image.o -c read_image.c -Wall


histogrammes.o : histogrammes.c histogrammes.h
	gcc -o histogrammes.o -c histogrammes.c -Wall -lm

clean :
	rm *.o main
