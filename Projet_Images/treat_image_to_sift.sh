mkdir mes_sifts
./colorDescriptor --descriptor sift $1 --output tmp1
more tmp1 | sed -n '4,$p' $f | tr -d ";" | sed 's/<CIRCLE [1-9].*> //' > tmp2
R --slave --no-save --no-restore --no-environ --args centers256.txt 256 tmp2 mes_sifts/`basename $1`.sift < 1nn.R

rm tmp1 tmp2

./create_histo_cluster.exe mes_sifts/`basename $1`.sift cluster.html $1


