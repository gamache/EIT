package NHT::Trophy::DeathRay;

sub name { "death_ray" }

sub results { 
  my ($class, $nht) = @_;

  my %deathray;
  for my $game (@{ $nht->games }) {
    $deathray{ $game->{name} }++ if $game->{death}=~/death ray/;
  }

  my @deathrays = map { { player => $_, value => $deathray{$_} } }
    sort { $deathray{$b} <=> $deathray{$a} } keys %deathray;

  return \@deathrays;
}


86;
