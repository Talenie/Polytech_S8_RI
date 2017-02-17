sub StopWords($$)
{
	my($Path,$StopFile)= @_;
	my $i = 1;
	my $str="1";
	
	
	open(FST,"$StopFile") || die "Erreur ouverture de $StopFile";
	
	my %stop_words;
	
	while(chop($word=<FST>)){
		$stop_words{$word} = 1;
	}
	
	#while( my ($id, $val) = each %stop_words){
	#	print "$id : $val\n";
	#}
	
    while($i <= 3204){
		open(FS,"$Path/CACM-$i.flt") || die "Erreur d'ouverture du fichier $Path/CACM-$i.flt\n";
		open(FLT,">STP/CACM-$i.stp") || die "Erreur de creation de CACM-$i.plt\n";
		
		while(<FS>){
			for $mot (split){
				if (exists $stop_words{$mot}){
					#print "Enleve : $mot\n";
				} else {
					#print "Garde : $str\n";
					print FLT "$mot ";
				}
			}
		}
		close(F);
		close(FLT);
		$i = $i +1;
	}
}

StopWords("../TP1-2/Filtre","common_words");
