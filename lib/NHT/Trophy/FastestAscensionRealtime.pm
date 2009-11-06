package NHT::Trophy::FastestAscensionRealtime;

sub name { 'fastest_ascension_realtime' }

sub results {
  my ($class, $nht) = @_;
  
  my @fast = map { { player => $_->{name}, value => $_->{realtime_hms}, game => $_ } }
    sort { $a->{realtime} <=> $b->{realtime} } @{$nht->ascensions};

  return \@fast;
}


2;
