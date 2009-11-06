package NHT::Trophy::AscensionsPerGame;

sub name { 'ascensions_per_game' }

sub results {
	my ($class, $nht) = @_;

	my %ngames;
	my %asc;
	for my $game (@{ $nht->games }) {
		$ngames{ $game->{name} }++;
		$asc{ $game->{name} } += $game->{ascended};
	}

	my %apg;
	for my $name (keys %ngames) {
		$apg{$name} = $asc{$name} / $ngames{$name};
	}
		
	return [
		map { { player => $_, value => sprintf('%.2f', $apg{$_}) } } 
			sort { $apg{$b} <=> $apg{$a} }
				keys %apg
	];
}

1;

