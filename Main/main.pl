#############
# FONCTIONS #
#############
sub ExtractionDesFichiers($$)
{
   my ($FileName,$Path)=@_; # Tableau des paramètres 
   open(F,$FileName) || die "Erreur d'ouverture du fichier $FileName\n";
   my $str="";
   my $Num=0;

   open(COL,">$Path/Collection") || die "Erreur de creation de Collection\n";
   while(!eof(F)){
     if($str =~m /\.I\s/){ # On regarde si s$tr contient la chaîne .I
        close(NF);
        $str =~s/\.I\s//g; # Dans $str, on supprime la chaîne .I avant le numéro de document
        $Num=$str;
        print COL "CACM-$Num\n";
        print "Processing ... CACM-$Num\n";
        open(NF,">$Path/CACM-$Num");
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

sub ExtractionDesQuerys($$)
{
   my ($FileName,$Path)=@_; # Tableau des paramètres 
   open(F,$FileName) || die "Erreur d'ouverture du fichier $FileName\n";
   my $str="";
   my $Num=0;

   open(COL,">$Path/Collection") || die "Erreur de creation de Collection\n";
   while(!eof(F)){
     if($str =~m /\.I\s/){ # On regarde si s$tr contient la chaîne .I
        close(NF);
        $str =~s/\.I\s//g; # Dans $str, on supprime la chaîne .I avant le numéro de document
        $Num=$str;
        print COL "Query-$Num\n";
        print "Processing ... Query-$Num\n";
        open(NF,">$Path/Query-$Num");
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

sub FiltrerAlphanumQuery($)
{
	my($Path)= @_;
	my $i = 1;
	my $str="1";
    while($i <= 64){
		open(FS,"$Path/Query-$i") || die "Erreur d'ouverture du fichier Query-$i\n";
		open(FLT,">FiltreQ/Query-$i.flt") || die "Erreur de creation de Query-$i.flt\n";
		
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

sub StopWordsQuery($$)
{
	my($Path,$StopFile)= @_;
	my $i = 1;
	my $str="1";
	
	
	open(FST,"$StopFile") || die "Erreur ouverture de $StopFile";
	
	my %stop_words;
	
	while(chop($word=<FST>)){
		$stop_words{$word} = 1;
	}
	
    while($i <= 64){
		open(FS,"$Path/Query-$i.flt") || die "Erreur d'ouverture du fichier $Path/Query-$i.flt\n";
		open(FLT,">STPQ/Query-$i.stp") || die "Erreur de creation de Query-$i.plt\n";
		
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

sub representation_binaire($$)
{
	my($file_voc,$Path)= @_;
		
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
	
	
	$i = 1;
	while($i <= 3204){
		open(F,"$Path/CACM-$i.stp") || die "Erreur d'ouverture du fichier $Path/CACM-$i.stp\n";
		my %rep;
		my %rep_fq;
		while(<F>){
			for $mot (split){
				$indice = $voc{$mot};
				$rep{$indice} = 1;
				$rep_fq{$indice} = $rep_fq{$indice} + 1 ;
			}
		}
		close(F);
		
		open(FREP,">Representations/CACM-$i.bi") || die "Erreur de creation du fichier Representations/CACM-$i.bi\n";
		foreach my $indice (sort {$a <=> $b} keys %rep) {
			print FREP "$indice:$rep{$indice}\n";
		}
		
		close(FREP);
		
		
		open(FREQ,">Representations/CACM-$i.fq") || die "Erreur de creation du fichier Representations/CACM-$i.fq\n";
		foreach my $indice (sort {$a <=> $b} keys %rep) {
			print FREQ "$indice:$rep_fq{$indice}\n";
		}
		
		close(FREQ);
		$i = $i+1;
	}
	
}

sub representation_binaire_query($$)
{
	my($file_voc,$Path)= @_;
		
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
	
	
	$i = 1;
	while($i <= 64){
		open(F,"$Path/Query-$i.stp") || die "Erreur d'ouverture du fichier $Path/Query-$i.stp\n";
		my %rep;
		my %rep_fq;
		while(<F>){
			for $mot (split){
				$indice = $voc{$mot};
				$rep{$indice} = 1;
				$rep_fq{$indice} = $rep_fq{$indice} + 1 ;
			}
		}
		close(F);
		
		open(FREP,">RepresentationsQuery/Query-$i.bi") || die "Erreur de creation du fichier Representations/CACM-$i.bi\n";
		foreach my $indice (sort {$a <=> $b} keys %rep) {
			print FREP "$indice:$rep{$indice}\n";
		}
		
		close(FREP);
		
		
		open(FREQ,">RepresentationsQuery/Query-$i.fq") || die "Erreur de creation du fichier Representations/CACM-$i.fq\n";
		foreach my $indice (sort {$a <=> $b} keys %rep) {
			print FREQ "$indice:$rep_fq{$indice}\n";
		}
		
		close(FREQ);
		$i = $i+1;
	}
	
}
#############
# MAIN PROG #
#############

ExtractionDesFichiers("cacm.all","Docs");
FiltrerAlphanum("Docs");
StopWords("Filtre","common_words");
createVoc("STP");
create_df("STP","vocabulaire");
representation_binaire("vocabulaire","STP");
ExtractionDesQuerys("query.text","Querys");
FiltrerAlphanumQuery("Querys");
StopWordsQuery("FiltreQ","common_words");
representation_binaire_query("vocabulaire","STPQ");



