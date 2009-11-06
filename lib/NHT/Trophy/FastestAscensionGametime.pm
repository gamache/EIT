package NHT::Trophy::FastestAscensionGametime;

sub name { 'fastest_ascension_gametime' }

sub results {
  my ($class, $nht) = @_;
  
  my @fast = map { { player => $_->{name}, value => $_->{turns}, game => $_ } }
    sort { $a->{turns} <=> $b->{turns} } @{ $nht->ascensions };

  return \@fast;
}


2;
