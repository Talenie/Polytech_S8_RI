sub create_df($$)
{
	my($Path,$vocFile)= @_;
	my $i = 1;
	
	my %voc;
		
    while($i <= 3204){
		open(FS,"$Path/CACM-$i.stp") || die "Erreur d'ouverture du fichier $Path/CACM-$i.stp\n";
		my %doc;
		while(<FS>){
			for $mot (split){
				$doc{$mot} = 1;
			}
		}
		close(FS);
		
		while( my ($mot, $val) = each %doc){
			if(exists $voc{$mot}){
				$voc{$mot} = $voc{$mot} + 1;
			} else {
				$voc{$mot} = 1;
			}
		}
		
		$i = $i +1;
	}
	
	open(FDF,">document_frequency") || die "Erreur de creation de document_frequency\n";
	
	while( my ($mot, $val) = each %voc){
		print FDF "$val $mot\n";
	}
	
	close(FDF);
}

create_df("STP","vocabulaire");

