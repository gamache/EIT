package NHT::Trophy::Stoners;

sub name { 'stoners' }

sub results {
	my ($class, $nht) = @_;
	
	my %stoner;
	for my $game (@{ $nht->games }) {
		$stoner{ $game->{name} }++ if $game->{death}=~/petrified/;
	}
	
	my @stoners = map { { player => $_, value => $stoner{$_} } }
		sort { $stoner{$b} <=> $stoner{$a} } keys %stoner;
	
	return \@stoners;
}

420;