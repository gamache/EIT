package NHT::Trophy::Anorexics;

sub name { "anorexics" }

sub results {
  my ($self, $nht) = @_;

  my %anorexic;
  for my $game (@{ $nht->games }) {
    $anorexic{ $game->{name} }++ if $game->{death} eq 'died of starvation';
  }
  
  my @anorexics = map { { player => $_, value => $anorexic{$_} } }
    sort { $anorexic{$b} <=> $anorexic{$a} } keys %anorexic;

  return \@anorexics;
}

"I like big butts and I cannot lie";
