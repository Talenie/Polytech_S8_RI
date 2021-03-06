#############
# FONCTIONS #
#############

# Parametres : Nom du fichier d'extraction, Chemin des fichiers, nom  des fichiers
sub ExtractionDesFichiers($$$)
{
   my ($FileName,$Path,$Name)=@_; # Tableau des paramètres 
   open(F,$FileName) || die "Erreur d'ouverture du fichier $FileName\n";
   my $str="";
   my $Num=0;
	
	# Si le $Path n'existe pas on le crée
	if (!(-d $Path)){
		system("mkdir $Path");
	}
   open(COL,">$Path/Collection") || die "Erreur de creation de Collection\n";
   while(!eof(F)){
     if($str =~m /\.I\s/){ # On regarde si s$tr contient la chaîne .I
        close(NF);
        $str =~s/\.I\s//g; # Dans $str, on supprime la chaîne .I avant le numéro de document
        $Num=$str;
        print COL "$Name-$Num\n";
        #print "Processing ... $Name-$Num\n";
        open(NF,">$Path/$Name-$Num");
     }
     if(($str=~ m/\.T/) || ($str=~ m/\.A/) || ($str=~ m/\.W/) || ($str=~ m/\.B/)) { # Si $str contient une des balises que l'on veut 
        $Go=1;
        while($Go==1){  # Tant que l'on ne rencontre pas une nouvelle balise
           chop($str=<F>);
           if(($str eq "\.W") || ($str eq "\.B") || ($str eq "\.N") || ($str eq "\.A") || ($str eq "\.X") || ($str eq "\.K") || ($str eq "\.T") || ($str eq "\.I")){
             $Go=0;
             break;
           }
           else{
             print NF "$str "; # On écrit le contenu dans le fichier CACM-XX
           }
        }
     }
     else{
       chop($str=<F>);
     }
  }
  close(F);
}

# Enleve les caractère alphanumériques
# Paramètres : Chemin des fichiers en entrée, leur nom, le chemin de sortie et le nombre à traiter
sub FiltrerAlphanum($$$$)
{
	my($PathIn,$Name,$PathOut,$num)= @_;
	my $i = 1;
	my $str="1";
	
	# Si le $Path n'existe pas on le crée
	if (!(-d $PathOut)){
		system("mkdir $PathOut");
	}
	
    while($i <= $num){
		open(FS,"$PathIn/$Name-$i") || die "Erreur d'ouverture du fichier $Name-$i\n";
		open(FLT,">$PathOut/$Name-$i.flt") || die "Erreur de creation de $Name-$i.flt\n";
		
		while(chop($str=<FS>)){
			$str = lc( $str );
			# on applique le filtre
			$str =~ s/(\,|\=|\/|\.|\?|\'|\(|\)|\_|\$|\%|\+|\[|\]|\{|\}|\&|\;|\:|\~|\!|\@|\#|\^|\*|\||\<|\>|\-|\\s|\\|\")//g;
			print FLT "$str";
		}
		close(F);
		close(FLT);
		$i = $i +1;
	}
}

# Enleve des fichier les mots présent dans StopFile
# Paramètres : Chemin, nom des fichies, nombre de fichiers, fichier avec les mots,  chemin en sortie
sub StopWords($$$$$)
{
	my($PathIn,$Name,$Num,$StopFile,$PathOut)= @_;
	my $i = 1;
	my $str="1";
	
	
	open(FST,"$StopFile") || die "Erreur ouverture de $StopFile";
	
	my %stop_words;
	
	while(chop($word=<FST>)){
		$stop_words{$word} = 1;
	}
	
	# Si le $Path n'existe pas on le crée
	if (!(-d $PathOut)){
		system("mkdir $PathOut");
	}
	
	
    while($i <= $Num){
		open(FS,"$PathIn/$Name-$i.flt") || die "Erreur d'ouverture du fichier $PathIn/$Name-$i.flt\n";
		open(FLT,">$PathOut/$Name-$i.stp") || die "Erreur de creation de $Name-$i.plt\n";
		
		while(<FS>){
			for $mot (split){
				if (exists $stop_words{$mot}){
					# Enleve le mot
				} else {
					print FLT "$mot ";
				}
			}
		}
		close(F);
		close(FLT);
		$i = $i +1;
	}
}

# Crée un vocabulaire a partir des fichiers dans Path et les place dans Name
# Paramètres : Chemin des fichiers de la collection, nom du fichier de vocabulaire en sortie
sub createVoc($$)
{
	my($Path,$Name)= @_;
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
	
	open(FV,">$Name") || die "Erreur de creation de $Name\n";
	
	while( my ($mot, $val) = each %voc){
		print FV "$mot\n";
	}
}

# Crée la DF d'une collection de fichiers
# Paramètres
#	Chemin de la collection
#	Nom des fichiers de la collection
#	Nombre de fichiers
# 	Document du vocabulaire
#	Nom de fichier de sortie
sub create_df($$$$$)
{
	my($Path,$Name,$Num,$vocFile,$outFile)= @_;
	my $i = 1;
	
	my %voc;
		
    while($i <= $Num){
		open(FS,"$Path/$Name-$i.stp") || die "Erreur d'ouverture du fichier $Path/$Name-$i.stp\n";
		my %doc;
		while(<FS>){
			for $mot (split){
				$doc{$mot} = 1;
			}
		}
		close(FS);
		
		while( my ($mot, $val) = each %doc){
			# Si le mot a été deja vu on ajoute 1 au df sinon on initialise à 1 (vu 1 fois)
			if(exists $voc{$mot}){
				$voc{$mot} = $voc{$mot} + 1;
			} else {
				$voc{$mot} = 1;
			}
		}
		
		$i = $i +1;
	}
	
	open(FDF,">$outFile") || die "Erreur de creation de $outFile\n";
	
	while( my ($mot, $val) = each %voc){
		print FDF "$val $mot\n";
	}
	
	close(FDF);
}



# Paramètres
# 	Document du vocabulaire
#	Document contenant les document frequency
#	Chemin de la collection
#	Nom des fichiers de la collection
#	Nombre de fichiers
#	Chemin de sortie des représentations binaires
#	Chemin de sortie des représentations fréquentielles
#	Chemin de sortie des représentations tfidf
sub representations($$$$$$$$)
{
	my($Voc,$DF,$PathIn,$Name,$Num,$PathBi,$PathFq,$PathTF)= @_;
		
	my %voc;
	my %reverse;
	
	open(FS,"$Voc") || die "Erreur d'ouverture du fichier $Voc\n";
	my $i = 1;
	while(<FS>){
		for $mot (split){
			$voc{$mot} = $i;
			$reverse{$i} = $mot;
			$i = $i+1;
		}
	}
	close(FS);
	
	my %df;
	
	open(FDF,"$DF") || die "Erreur d'ouverture du fichier $DF\n";
	my $i = 1;
	my $str = "";
	while(chop($str=<FDF>)){
		my @words = split / /,$str;
		$val = $words[0];
		$mot = $words[1];
		$mot =~ s/^\n//;
		$df{$mot} = $val;
	}
	close(FDF);
	
	
	# Si le $Path n'existe pas on le crée
	if (!(-d $PathBi)){
		system("mkdir $PathBi");
	}
	# Si le $Path n'existe pas on le crée
	if (!(-d $PathFq)){
		system("mkdir $PathFq");
	}
	# Si le $Path n'existe pas on le crée
	if (!(-d $PathTF)){
		system("mkdir $PathTF");
	}
	
	$i = 1;
	while($i <= $Num){
		open(F,"$PathIn/$Name-$i.stp") || die "Erreur d'ouverture du fichier $PathIn/$Name-$i.stp\n";
		my %rep;
		my %rep_fq;
		while(<F>){
			for $mot (split){
				if(exists $voc{$mot}){
					$indice = $voc{$mot};
					$rep{$indice} = 1;
					$rep_fq{$indice} = $rep_fq{$indice} + 1 ;
				}
			}
		}
		close(F);
		
		# on écrit la représentation binaire
		open(FREP,">$PathBi/$Name-$i.bi") || die "Erreur de creation du fichier $PathBi/$Name-$i.bi\n";
		foreach my $indice (sort {$a <=> $b} keys %rep) {
			print FREP "$indice:$rep{$indice}\n";
		}
		close(FREP);
		
		
		# on écrit la représentation fréquentielle
		open(FREQ,">$PathFq/$Name-$i.fq") || die "Erreur de creation du fichier $PathFq/$Name-$i.fq\n";
		foreach my $indice (sort {$a <=> $b} keys %rep_fq) {
			print FREQ "$indice:$rep_fq{$indice}\n";
		}
		close(FREQ);
		
		
		# on écrit la représentation tfid
		open(FRET,">$PathTF/$Name-$i.tfid") || die "Erreur de creation du fichier $PathTF/$Name-$i.tfid\n";
		foreach my $indice (sort {$a <=> $b} keys %rep_fq) {
			my $word = $reverse{$indice}; # mot correspondant à l'indice
			my $docF = $df{$word};
			if($docF!=0){
				my $tfid = ($rep_fq{$indice}*log($Num/$docF));
				print FRET "$indice:$tfid\n";
			}
		}
		close(FRET);
		
		$i = $i+1;
	}
	
}

#############
# MAIN PROG #
#############


# Extraction, création de représentations des fichiers CACM
ExtractionDesFichiers("cacm.all","Docs","CACM");
FiltrerAlphanum("Docs","CACM","Filtre",3204);
StopWords("Filtre","CACM",3204,"common_words","STP");
createVoc("STP","vocabulaire");
create_df("STP","CACM",3204,"vocabulaire","document_frequency");
representations("vocabulaire","document_frequency","STP","CACM",3204,"RepBi","RepFq","RepTFID");

# Représentation des Querys dans le même espace que les documents
ExtractionDesFichiers("query.text","Querys","Query");
FiltrerAlphanum("Querys","Query","FiltreQ",64);
StopWords("FiltreQ","Query",64,"common_words","STPQ");
representations("vocabulaire","document_frequency","STPQ","Query",64,"RepBiQ","RepFqQ","None");
system("rm -r None");


