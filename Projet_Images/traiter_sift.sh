ls ./sift > files.tmp

while read line
do	
	echo "Traitement $line"
	fichier=./sift/$line
	tail -n +4 $fichier | awk "NR%150==0" | sed -rn 's/<.*>; *(.*);/\1/p' > clean/$line
done < files.tmp

rm files.tmp
