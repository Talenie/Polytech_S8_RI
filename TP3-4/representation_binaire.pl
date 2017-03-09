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

sub representation_frequentielle($$$)
{
	my($file_voc,$file_df,$file_doc)= @_;
		
	my %rep;
	my %voc;
	my %df;
	
	open(FS,"$file_voc") || die "Erreur d'ouverture du fichier $file_voc\n";
	my $i = 1;
	while(<FS>){
		for $mot (split){
			$voc{$mot} = $i;
			$i = $i+1;
		}
	}
	close(FS);
	
	open(FD,"$file_df") || die "Erreur d'ouverture du fichier $file_df\n";
	while(<FD>){
		chomp :
			my @mots = split(/ /);
			$df{$mots[1]} = $mots[0];
	}
	close(FD);
		
	open(F,"$file_doc") || die "Erreur d'ouverture du fichier $file_doc\n";
	
	while(<F>){
		for $mot (split){
			$indice = $voc{$mot};
			$rep{$indice} = $df{$mot};
		}
	}
	close(F);
	
	while( my ($ind, $val) = each %rep){
		print "$ind : $val\n";
	}
}

representation_frequentielle("vocabulaire","document_frequency","STP/CACM-689.stp");
