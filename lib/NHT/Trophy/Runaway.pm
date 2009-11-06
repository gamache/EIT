package NHT::Trophy::Runaway;

sub name { 'runaway' }

sub results {
	my ($class, $nht) = @_;

	my @leaders = (
		'The Minion of Huhetotl',
		'Thoth Amon',
	  'The Chromatic Dragon',
	  'The Cyclops',
	  'Ixoth',
		'Master Kaen',
		'Nalzok',
		'Scorpius',
		'The Master Assassin',
		'Ashikaga Takauji',
		'The Master of Thieves',
		'Lord Surtur',
		'The Dark One',
	);

	my %failers;
	for my $game (@{ $nht->games }) {
		my $died_on_quest = 0;
		for my $leader (@leaders) {
			$died_on_quest=1 if $game->{death}=~/killed by $leader/i;
		}
		$failers{ $game->{name} }++ if $died_on_quest;
	}

	return [
		map { { player => $_, value => $failers{$_} } }
			sort { $failers{$b} <=> $failers{$a} }
				keys %failers
	];
}

'the other monty';
