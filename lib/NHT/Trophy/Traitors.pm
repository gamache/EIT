package NHT::Trophy::Traitors;

sub name { "traitors" }

sub results {
  my ($class, $nht) = @_;

  my %traitor;
  for my $game (@{$nht->games}) {
    $traitor{ $game->{name} }++ if $game->{align0} ne $game->{align};
  }
  
  my @traitors = map { { player => $_, value => $traitor{$_} } }
    sort { $traitor{$b} <=> $traitor{$a} } keys %traitor;

  return \@traitors;
}


206;
