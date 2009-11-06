package NHT::Trophy::Transsexuals;

sub name { "transsexuals" }

sub results {
  my ($class, $nht) = @_;
  
  my %trans;
  for my $game (@{$nht->games}) {
    $trans{ $game->{name} }++ if $game->{gender0} ne $game->{gender};
  }
  
  my @trannies = map { { player => $_, value => $trans{$_} } }
    sort { $trans{$b} <=> $trans{$a} } keys %trans;

  return \@trannies;
}


'This one goes out to Clan MIT';
