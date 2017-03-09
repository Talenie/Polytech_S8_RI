sub cosine($$$) {
	
	my ($fdocument,$fquery,$fvoc)=@_; # Tableau des paramètres 
	
	my %voc;
	
	open(FV,"$fvoc") || die "Erreur d'ouverture du fichier $fvoc\n";
	while(<FV>) {
		for $line (split) {
			@content = split(/(:)/, $line);
			print "$content[0]	$content[2]\n";
			$voc{$content[2]} = $content[0];
		}
	}
	close(FV);
	
	my %doc;
	open(FD,"$fdocument") || die "Erreur d'ouverture du fichier $fdocument\n";
	while(<FD>) {
		for $line (split) {
			@content = split(/(:)/, $line);
			$doc{$content[0]} = $content[2];
			print "$content[0]	$content[2]\n";
		}
	}
	close(FD);
	
}

#cosine($ARGV[0], $ARGV[1], $ARGV[2]);
