package NHT::Trophy::FirstAscension;

sub name { 'first_ascension' }

sub results {
  my ($class, $nht) = @_;

  my @first = map { { player => $_->{name}, value => $_->{endtime_date}, game => $_ } }
    sort { $a->{endtime} <=> $b->{endtime} } @{$nht->ascensions};

  return \@first;
}
		    
1;
