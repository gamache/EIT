package NHT::Trophy::BestBehavedAscension;

sub name { "best_behaved_ascension" }

sub results {
  my ($class, $nht) = @_;

  my @asc_games = sort 
    { $b->{conduct} <=> $a->{conduct} or $b->{points} <=> $a->{points} }
    @{ $nht->ascensions };
  
  my @ascs = map { 
      { player => $_->{name}, 
	    value => $_->{conduct}, 
	    game => $_,
      }             
  } @asc_games;

  return \@ascs;
}


69;
