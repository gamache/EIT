package NHT::Trophy::SlowestAscensionGametime;
use strict;
use warnings;

sub name {"slowest_ascension_gametime"}

sub results {
  my ($class, $nht) = @_;
  
  my @slow = map { { player => $_->{name}, value => $_->{turns} } }
    sort { $b->{turns} <=> $a->{turns} } @{$nht->ascensions};

  return \@slow;
}


99E9;
