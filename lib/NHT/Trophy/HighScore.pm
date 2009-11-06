package NHT::Trophy::HighScore;

sub name { 'high_score' }

sub results {
	my ($class, $nht) = @_;
	
	return [ 
		map { { player => $_->{name}, value => $_->{points}, game => $_ } }
			@{ $nht->high_scores }
	];
}

2.2222E09;