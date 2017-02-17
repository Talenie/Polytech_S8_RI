sub representation_binaire($$)
{
	my($file_voc,$file_doc)= @_;
		
	my %rep;
	my %voc;
	
	open(FS,"$file_voc") || die "Erreur d'ouverture du fichier $file_voc\n";
	
	my $i = 1;
	
	while(<FS>){
		for $mot (split){
			$voc{$mot} = $i;
			$i = $i+1;
		}
	}
	close(FS);
	
	#while( my ($ind, $val) = each %voc){
	#	print "$ind : $val\n";
	#}
	
	open(F,"$file_doc") || die "Erreur d'ouverture du fichier $file_doc\n";
	
	while(<F>){
		for $mot (split){
			$indice = $voc{$mot};
			$rep{$indice} = 1;
		}
	}
	close(F);
	
	while( my ($ind, $val) = each %rep){
		print "$ind : $val\n";
	}
}

sub representation_frequentielle($$)
{
	my($file_voc,$file_doc)= @_;
		
	my %rep;
	my %voc;
	
	open(FS,"$file_voc") || die "Erreur d'ouverture du fichier $file_voc\n";
	
	my $i = 1;
	
	while(<FS>){
		for $mot (split){
			$voc{$mot} = $i;
			$i = $i+1;
		}
	}
	close(FS);
	
	#while( my ($ind, $val) = each %voc){
	#	print "$ind : $val\n";
	#}
	
	open(F,"$file_doc") || die "Erreur d'ouverture du fichier $file_doc\n";
	
	while(<F>){
		for $mot (split){
			$indice = $voc{$mot};
			if(exists $rep{$indice}) {
				$rep{$indice} = $rep{$indice}+1;
			} else {
			$rep{$indice} = 1;
			}
		}
	}
	close(F);
	
	while( my ($ind, $val) = each %rep){
		print "$ind : $val\n";
	}
}



representation_frequentielle("vocabulaire","STP/CACM-689.stp");
