package NHT::Trophy::SoClose;

sub name { 'so_close' }

sub results {
	my ($class, $nht) = @_;
	
	my %so_close;
	for my $game (@{ $nht->games }) {
		$so_close{ $game->{name} }++ if 
			$game->{got_amulet} &&
			$game->{ascended}==0 && 
			$game->{death}=~/with the Amulet/;
	}
	
	my @so_closes = map { { player => $_, value => $so_close{$_} } }
		sort { $so_close{$b} <=> $so_close{$a} } keys %so_close;
	
	return \@so_closes;
}

420;
