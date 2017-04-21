

all : read_image.exe create_histos.exe create_histo_cluster.exe create_histo_combine.exe

read_image.exe :  rdjpeg.o read_image.o histogrammes.o proc.o
	gcc rdjpeg.o read_image.o histogrammes.o proc.o -o read_image.exe -lm
	
create_histos.exe : rdjpeg.o main.o histogrammes.o proc.o
	gcc rdjpeg.o main.o histogrammes.o proc.o -o create_histos.exe 
	
create_histo_cluster.exe : rdjpeg.o main_cluster.o histogrammes.o proc.o
	gcc rdjpeg.o histogrammes.o proc.o main_cluster.o -o create_histo_cluster.exe

create_histo_combine.exe : rdjpeg.o main_combine.o histogrammes.o proc.o
	gcc rdjpeg.o histogrammes.o proc.o main_combine.o -o create_histo_combine.exe
	
main.o : main.c
	gcc -o main.o -c main.c -Wall
	
main_cluster.o : main_cluster.c
	gcc -o main_cluster.o -c main_cluster.c -Wall
	
main_combine.i : main_combine.c
	gcc -o main_combine.o -c main_combine.c -Wall

rdjpeg.o : rdjpeg.c rdjpeg.h
	gcc -o rdjpeg.o -c rdjpeg.c -Wall


read_image.o : read_image.c
	gcc -o read_image.o -c read_image.c -Wall


histogrammes.o : histogrammes.c histogrammes.h
	gcc -o histogrammes.o -c histogrammes.c -Wall -lm

clean :
	rm *.o *.exe
