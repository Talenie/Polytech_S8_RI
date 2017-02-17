sub createVoc($)
{
	my($Path)= @_;
	my $i = 1;
	my $str="1";
	
	my %voc;
	
    while($i <= 3204){
		open(FS,"$Path/CACM-$i.stp") || die "Erreur d'ouverture du fichier $Path/CACM-$i.stp\n";
		
		while(<FS>){
			for $mot (split){
				$voc{$mot} = 1;
			}
		}
		close(F);
		close(FLT);
		$i = $i +1;
	}
	
	open(FV,">vocabulaire") || die "Erreur de creation de vocabulaire\n";
	
	while( my ($mot, $val) = each %voc){
		print FV "$mot\n";
	}
}

createVoc("STP");
