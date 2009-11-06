package NHT::Trophy::FirstDeath;

sub name { 'first_death' }

sub results {
	my ($class, $nht) = @_;

	my @fd = 
		map { {player => $_->{name}, value => $_->{starttime_date}, game => $_} }
			sort { $a->{starttime} <=> $b->{starttime} }
				grep { $_->{death}!~/^(escaped|quit|ascended)/ }
					@{ $nht->games };

	return \@fd;
}

86;
