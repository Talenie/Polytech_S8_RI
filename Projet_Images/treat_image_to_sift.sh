\mkdir mes_sifts
./colorDescriptor --descriptor sift $1 --output tmp1

echo "Traitrement de $1"
sed -n '4,$p' tmp1 | tr -d ";" | sed 's/<CIRCLE [1-9].*> //' > ./trav.sift
R --slave --no-save --no-restore --no-environ --args centers256.txt 256 ./trav.sift ./res.sift < 1nn.R
mv ./res.sift mes_sifts/`basename $1`.sift

\rm -f ./trav.sift ./res.sift tmp1

./create_histo_cluster.exe mes_sifts/`basename $1`.sift cluster.html $1


