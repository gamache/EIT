package NHT::Trophy::SlowestAscensionRealtime;
use strict;
use warnings;

sub name {"slowest_ascension_realtime"}

sub results {
  my ($class, $nht) = @_;
  
  my @slow = map { { player => $_->{name}, value => $_->{realtime_hms} } }
    sort { $b->{realtime} <=> $a->{realtime} } @{$nht->ascensions};

  return \@slow;
}


99E9;
