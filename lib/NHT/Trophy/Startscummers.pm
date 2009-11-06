package NHT::Trophy::Startscummers;

sub name { "startscummers" }

sub results {
  my ($class, $nht) = @_;

  my %scummer;
  for my $game (@{$nht->games}) {
    $scummer{ $game->{name} }++ if $game->{turns} < 5 && 
                                   $game->{death} =~ /(quit|escaped)/;
  }

  my @scum = map { { player => $_, value => $scummer{$_} } }
    sort { $scummer{$b} <=> $scummer{$a} } keys %scummer;

  return \@scum;
}


6.02E23;
