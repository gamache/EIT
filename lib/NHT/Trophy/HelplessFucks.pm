package NHT::Trophy::HelplessFucks;

sub name { "helpless_fucks" }

sub results {
  my ($class, $nht) = @_;
  
  my %helpless;
  for my $game (@{$nht->games}) {
    $helpless{ $game->{name} }++ if $game->{death}=~/helpless/;
  }
  
  my @help = map { { player => $_, value => $helpless{$_} } }
    sort { $helpless{$b} <=> $helpless{$a} } keys %helpless;

  return \@help;
}

98.6;
