package NHT::Trophy::Trippers;

sub name { 'trippers' }

sub results {
	my ($class, $nht) = @_;
	
	my %tripper;
	for my $game (@{ $nht->games }) {
		$tripper{ $game->{name} }++ if $game->{death}=~/hallucinating/;
	}
	
	my @trippers = map { { player => $_, value => $tripper{$_} } }
		sort { $tripper{$b} <=> $tripper{$a} } keys %tripper;
	
	return \@trippers;
}

420;