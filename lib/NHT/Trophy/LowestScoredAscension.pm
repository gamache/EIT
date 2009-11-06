package NHT::Trophy::LowestScoredAscension;

sub name { 'lowest_scored_ascension' }

sub results {
  my ($class, $nht) = @_;

  my @low = map { { player => $_->{name}, value => $_->{points}, game => $_ } }
    sort { $a->{points} <=> $b->{points} } @{$nht->ascensions};

  return \@low;
}
		    
1;
