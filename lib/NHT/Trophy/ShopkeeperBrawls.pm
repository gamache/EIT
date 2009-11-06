package NHT::Trophy::ShopkeeperBrawls;

sub name { 'shopkeeper_brawls' }

sub results {
  my ($class, $nht) = @_;
  
  my %brawler;
  for my $game (@{$nht->games}) {
    $brawler{ $game->{name} }++ if $game->{death}=~/shopkeeper/;
  }

  my @brawlers = map { { player => $_, value => $brawler{$_} } }
    sort { $brawler{$b} <=> $brawler{$a} } keys %brawler;

  return \@brawlers;
}


0xdeadbeef;
