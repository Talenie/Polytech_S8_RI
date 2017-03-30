

all : read_image.exe create_histos.exe 

read_image.exe :  rdjpeg.o read_image.o histogrammes.o proc.o
	gcc rdjpeg.o read_image.o histogrammes.o proc.o -o read_image.exe -lm
	
create_histos.exe : rdjpeg.o main.o histogrammes.o proc.o
	gcc rdjpeg.o main.o histogrammes.o proc.o -o create_histos.exe 
	
main.o : main.c
	gcc -o main.o -c main.c -Wall

rdjpeg.o : rdjpeg.c rdjpeg.h
	gcc -o rdjpeg.o -c rdjpeg.c -Wall


read_image.o : read_image.c
	gcc -o read_image.o -c read_image.c -Wall


histogrammes.o : histogrammes.c histogrammes.h
	gcc -o histogrammes.o -c histogrammes.c -Wall -lm

clean :
	rm *.o *.exe
