package NHT::Trophy::MostAscensions;

sub name { return "most_ascensions" }

sub results {
  my ($class, $nht) = @_;

  my %asc = ();
  for my $player (@{ $nht->players }) {
    for my $game (@{ $nht->games($player) }) {
      $asc{$player}++ if $game->{ascended};
    }
  }
  
  my @most_asc = map { { player => $_, value => $asc{$_}, } } 
    sort { $asc{$b} <=> $asc{$a} } keys %asc;

  return \@most_asc;
}


22;
