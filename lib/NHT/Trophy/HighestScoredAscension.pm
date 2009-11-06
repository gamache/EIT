package NHT::Trophy::HighestScoredAscension;

sub name { 'highest_scored_ascension' }

sub results {
  my ($class, $nht) = @_;

  my @high = map { { player => $_->{name}, value => $_->{points}, game => $_ } }
    sort { $b->{points} <=> $a->{points} } @{$nht->ascensions};

  return \@high;
}
		    
1;
