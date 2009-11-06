package NHT::Trophy::GruesomeDeaths;

sub name { "gruesome_deaths" }

sub results {
  my ($class, $nht) = @_;

  my %grue;
  for my $game (@{$nht->games}) {
    $grue{ $game->{name} }++ if $game->{death} eq 'eaten by a Grue';
  }

  my @grues = map { { player => $_, value => $grue{$_} } }
    sort { $grue{$b} <=> $grue{$a} } keys %grue;

  return \@grues;
}


1979;
