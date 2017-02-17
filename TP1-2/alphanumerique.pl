sub FiltrerAlphanum($)
{
	my($Path)= @_;
	my $i = 1;
	my $str="1";
    while($i <= 3204){
		open(FS,"$Path/CACM-$i") || die "Erreur d'ouverture du fichier CACM-$i\n";
		open(FLT,">Filtre/CACM-$i.flt") || die "Erreur de creation de CACM-$i.flt\n";
		
		while(chop($str=<FS>)){
			$str = lc( $str );
			$str =~ s/(\,|\=|\/|\.|\?|\'|\(|\)|\_|\$|\%|\+|\[|\]|\{|\}|\&|\;|\:|\~|\!|\@|\#|\^|\*|\||\<|\>|\-|\\s|\\|\")//g;
			print FLT "$str";
		}
		close(F);
		close(FLT);
		$i = $i +1;
	}
}

FiltrerAlphanum("Doc");
