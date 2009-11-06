package NHT::Trophy::Underperformers;

sub name { 'underperformers' }

sub results {
	my ($class, $nht) = @_;

	return [ reverse @{ $nht->trophy('points_per_game') } ];
}

'F-';

