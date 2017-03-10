sub cosine($$) {
	
	my ($fdocument,$fquery)=@_; # Tableau des paramètres 
	
	#print "Running cosine $fdocument\n";
	
	my %doc;
	my $sumSquareDoc = 0;
	open(FD,"$fdocument") || die "Erreur d'ouverture du fichier $fdocument\n";
	while(<FD>) {
		for $line (split) {
			@content = split(/(:)/, $line);
			$doc{$content[0]} = $content[2];
			$sumSquareDoc += $content[2]**2;
		}
	}
	close(FD);
	
	#print "SquareSum  : $sumSquareDoc \n";
	
	my %query;
	my $sumSquareQuery = 0;
	open(FQ,"$fquery") || die "Erreur d'ouverture du fichier $fquery\n";
	while(<FQ>) {
		for $line (split) {
			@content = split(/(:)/, $line);
			$query{$content[0]} = $content[2];
			$sumSquareQuery += $content[2]**2;
		}
	}
	close(FQ);
	
	#print "SquareSum  : $sumSquareQuery \n";
	
	my $prodsc = 0;
	while( my ($wordid, $val) = each %query){
		if($doc{$wordid}) {
			$prodsc += $val*$doc{$wordid};
		}	
	}
	
	#print "$prodsc\n";
	$sqrtDQ = sqrt($sumSquareDoc*$sumSquareQuery);
	#print "$sqrtDQ\n";
	if($sqrtDQ==0) {
		$res = 0;
	} else {
		$res = $prodsc/$sqrtDQ;
	}
	#print "$res\n";
	
	return $res;
	
}

sub rank($$$) {

	my($nb, $dir, $query) = @_;	
	my @files = glob( $dir . '/*' );
	
	my %ranking;
	
	foreach my $filename (@files) {
		$ranking{$filename} = cosine($filename, $query);
	}
	
	my $rank = 0;
	print "rank	doc					proba\n";
	foreach my $key (reverse sort values %ranking) {
		if($rank++ < $nb) {
			print "$rank.	$key		$ranking{$key}\n";
		};
	}
	
	
}

#cosine($ARGV[0], $ARGV[1]);
rank($ARGV[0], $ARGV[1], $ARGV[2]);
