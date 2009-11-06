package NHT::Trophy::Gluttons;

sub name { "gluttons" }

sub results {
  my ($class, $nht) = @_;

  my %glutton;
  for my $game (@{$nht->games}) {
    $glutton{ $game->{name} }++ if $game->{death}=~/choked/;
  }

  my @gluttons = map { { player => $_, value => $glutton{$_} } }
    sort { $glutton{$b} <=> $glutton{$a} } keys %glutton;

  return \@gluttons;
}


400;
