package NHT::Trophy::Stars;
use NHT;
use Data::Dumper;

sub name { 'stars' }

sub results {
	my ($class, $nht) = @_;
	
	my @stars = @NHT::stars;
	
	my %star_map = (
	    dilithium => 'ascended',
	    platinum  => 'reached_astral',
	    gold      => 'reached_elemental',
	    silver    => 'got_amulet',
	    bronze    => 'did_invocation',
	    steel     => 'got_book',
	    brass     => 'got_candelabrum',
	    copper    => 'entered_gehennom',
	    zinc      => 'killed_medusa',
	    iron      => 'got_bell',
	    lead      => 'did_mines',
	    plastic   => 'did_sokoban',
	);
	
	
	## strategy: 
	## For each star, first collect a hashref of ( player => 1 ) pairs.
	## Then remove duplicates from higher-ranked stars (i.e. if you get dilithium, you
	##   can't also get any of the others).
	## Then turn each hashref, form a list of winners out of the keys.  
	## Then sort all these lists by player name.
	## Then map the lists to {player => $_}
	
	## make hashes, preventing duplicates
	my %achievers;
	my %winners;
    for my $ach (map {$star_map{$_}} @stars) {
    	for my $game (@{ $nht->games }) {
    	    if ($game->{$ach} && !$winners{$game->{name}}) {
    	        $achievers{$ach}{ $game->{name} } = 1;
    	        $winners{ $game->{name} } = 1;
    	    }
	    }
	}
	
	## we should also remove those who won a Monty Trophy from the dilithium stars
	## we can get away with this because the montys have already been computed
	for my $monty (@NHT::montys) {
	    for (@{ $nht->trophy($monty) }) {
	        delete $achievers{ascended}{$_->{player}};
	    }
	}
	
    ## out of the hashes, make the lists of winners
	my %results;
	while (my ($star, $ach) = each %star_map) {
	    $results{$star} = [ keys %{ $achievers{$ach} } ];
	}
	
	## sort each list alphabetically, and map each list to {player => $_}
	for my $star (keys %results) {
	    $results{$star} = [ 
	        map { { player => $_ } }
    	        sort { $a cmp $b } @{$results{$star}} 
	    ];
	}
	
	return \%results;
}

'billions and billions';