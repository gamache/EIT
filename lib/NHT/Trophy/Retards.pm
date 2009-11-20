package NHT::Trophy::Retards;

sub name { 'retards' }

sub results {
	my ($class, $nht) = @_;

	my %tard;
	for my $game (@{ $nht->games }) {
		$tard{ $game->{name} }++ if $game->{death}=~/^killed by brainlessness/;
	}

	return [
		map { { player => $_, value => $tard{$_} } }
			sort { $tard{$b} <=> $tard{$a} }
				keys %tard
	];
}

'DUH';
