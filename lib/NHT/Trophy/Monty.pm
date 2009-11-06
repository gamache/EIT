package NHT::Trophy::Monty;
use List::Util qw/sum/;

sub name { 'monty_trophies' }

sub results { 
    my ($class, $nht) = @_;
    
    my $full_monty = monty_results( $nht, 
        [ @NHT::roles, @NHT::races, @NHT::genders, @NHT::alignments, 
          @NHT::conducts ],
	);
	my $grand_slam = monty_results( $nht,
        [ @NHT::roles, @NHT::races, @NHT::genders, @NHT::alignments ],
        [ map { $_->{player} } @$full_monty ],
    );
    my $hat_trick = monty_results( $nht,
        [ @NHT::races, @NHT::genders, @NHT::alignments ],
        [ map { $_->{player} } @$full_monty, @$grand_slam ],
    );
    my $double_top = monty_results( $nht,
        [ @NHT::genders, @NHT::alignments ],
        [ map { $_->{player} } @$full_monty, @$grand_slam, @$hat_trick ],
    );
    my $birdie = monty_results( $nht,
        [ @NHT::genders ],
        [ map { $_->{player} } @$full_monty, @$grand_slam, @$hat_trick, 
                               @$double_top ],
    );

    return {
        full_monty => $full_monty,
        grand_slam => $grand_slam,
        hat_trick  => $hat_trick,
        double_top => $double_top,
        birdie     => $birdie,
    }

}


sub monty_results {
	my ($nht, $checklist_keys, $ineligible_players) = @_;
	
	my %ineligible_hash = map {$_ => 1} @{$ineligible_players || []};
	
	my @montys;
	for my $player (grep {!$ineligible_hash{$_}} @{$nht->ascenders}) {
	    my @games = grep {!$_->{trickery}} @{$nht->games($player)};
		my $monty = monty($nht, $checklist_keys, $player, 0, \@games);
	    push @montys, $monty if $monty;
	}

	# sort by player name
	@montys = sort { $a->{player} cmp $b->{player} } @montys;

	return \@montys;
}



sub monty {
	my ($nht, $checklist_keys, $player, $start_index, $games_ref, $best) = @_;
	#my $games_ref = $nht->games($player);
	return $best if $start_index >= @$games_ref;

	my $prev_checklist_items = 0;
	my $bells = 1;
	my %checklist = map {$_ => 0} @$checklist_keys;

	for my $game (@$games_ref[$start_index .. @$games_ref-1]) {
		unless ($game->{ascended}) {
			$bells = 0;
			next;
		}
		else {
			for my $key (@$checklist_keys) {
				$checklist{$key} = 1 if $game->{$key};
			}
			my $checklist_items = sum(values %checklist);

			last if $checklist_items == @$checklist_keys;

		    $bells = 0 unless $checklist_items > $prev_checklist_items;
		    $prev_checklist_items = $checklist_items;
		}
	}
	

	my $has_monty = scalar( grep {$_==0} values %checklist ) == 0;
	return monty($nht, $checklist_keys, $player, $start_index+1, $games_ref, $best)
		unless $has_monty;

	my $monty = { player => $player, value => $bells };
	return $monty if $bells;
	return monty($nht, $checklist_keys, $player, $start_index+1, $games_ref, $monty);
}



999;
