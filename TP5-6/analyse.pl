# Calcule le cosine d'une requête par rapport à un document
# $fdocument l'adresse du dossier où se trouvent le document
# $id le numéro du document
# $ext l'extension de fichier
# $fquery l'adresse complete du fichier de requete
sub cosine($$$$) {
	
	my ($fdocument, $id, $ext, $fquery)=@_; # Tableau des paramètres 
	
	#print "Running cosine $fdocument/$id\n";
	
	my %doc;
	my $sumSquareDoc = 0;
	open(FD,"$fdocument/CACM-$id.$ext") || die "Erreur d'ouverture du fichier $fdocument/CACM-$id.$ext\n";
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

# Retourne le fichier $fsortie contenant l'ensemble des $nb premiers documents pertinents pour la requête
# $nb le nombre de rangs à sortir
# $dir l'adresse du dossier où se trouvent le document
# $ext l'extension de fichier
# $query l'adresse complete du fichier de requete
# $fsortie l'adresse du fichier de sortie
sub rank($$$$$) {

	my($nb, $dir, $ext, $query, $fsortie) = @_;	
	my @files = glob( $dir . '/*' );
	
	my %ranking;
	
	# boucle pour tous les documents à tester
	my $i=1;
	while ($i<=3024) {
		$ranking{$i} = cosine($dir, $i, $ext, $query);
		$i++;
	}
	
	my $rank = 0;
	
	# inversion du hash array afin de récupérer la bonne clé pour la bonne proba
	my %reverseRanking;
	foreach my $key (keys %ranking) {
		$reverseRanking{$ranking{$key}} = $key;
	}
	
	# écriture du fichier de sortie
	open(FS,">$fsortie") || die "Erreur d'ouverture du fichier $fsortie\n";
	#print "rank	doc					proba\n";
	foreach my $value (reverse sort values %ranking) { # sort sur les probas
		if($rank++ < $nb) {
			$key = $reverseRanking{$value}; # récupération du nom du document
			print FS "$rank.	$key	$value\n";
		};
	}
	close(FS);
	
	
}

# Fonction permettant de calculer une précision moyenne à partir d'une requete sur des documents
#
# $fqrels l'adresse du fichier de référence
# $queryNb le numéro de la requête
# $nb le nombre de rangs à traiter
# $dir le dossier des documents à traiter
# $ext l'etenssion des fichiers à traiter
# $query l'adresse du fichier de requête
sub epk($$$$$$) {
	my($fqrels, $queryNb, $nb, $dir, $ext, $query) = @_;
	
	# enregistrement des fichiers pertinents pour la requête en question
	my %qrels;
	open(FQ,"$fqrels") || die "Erreur d'ouverture du fichier $fqrels\n";
	while ($line = <FQ>) {
		@content = split(/( )/, $line);
		if ($content[0] == $queryNb) {
			$qrels{$content[2]} = $content[0];
		}
	}
	close(FD);
	
	# choix du fichier de sauvegarde et calcul des similarités de documents
	my $frank = ".temp.rank";
	rank($nb, $dir, $ext, $query, $frank);
	
	my $matching = 0; # variable de concordance
	open(FR, "$frank") || die "Erreur d'ouverture du fichier $frank\n";
	while ($line = <FR>) {
		@content = split(/(	)/, $line);
		# si le document similaire est présent dans les document réellement cohérent avec la requête, on incrémente $matching
		if($qrels{$content[2]}) {
			$matching++;
		}
	}
	close(FR);
	
	return $matching/$nb;	# retour de la valeur finale en fonction du nombre de document triés
}

#cosine($ARGV[0], $ARGV[1]);
#rank($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3], $ARGV[4]);
epk($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3], $ARGV[4], $ARGV[5]);
