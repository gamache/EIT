package NHT::Trophy::PointsPerGame;

sub name { 'points_per_game' }

sub results {
	my ($class, $nht) = @_;

	my %ngames;
	my %points;
	for my $game (@{ $nht->games }) {
		$ngames{ $game->{name} }++;
		$points{ $game->{name} } += $game->{points};
	}

	my %ppg;
	for my $name (keys %ngames) {
		$ppg{$name} = int ($points{$name} / $ngames{$name});
	}
		
	return [
		map { { player => $_, value => $ppg{$_} } } 
			sort { $ppg{$b} <=> $ppg{$a} }
				grep { $ppg{$_} > 0 }
					keys %ppg
	];
}

1;

