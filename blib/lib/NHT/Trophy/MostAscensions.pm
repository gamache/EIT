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
  
  my @most_asc_players = sort { $asc{$b} <=> $asc{$a} } keys %asc;
  my @most_asc = map { {name => $_, value => $asc{$_} } } @most_asc_players;


  #use Data::Dumper;
  #warn Dumper [ @most_asc[0..9] ];
  return wantarray ? @most_asc : \@most_asc;
}


22;
