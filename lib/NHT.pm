package NHT;
use strict;
use warnings;

use NHT::Trophy;

use JSON::Any;


@NHT::roles   = qw{ Arc Bar Cav Hea Kni Mon Pri Rog Ran Sam Tou Val Wiz };
@NHT::genders = qw{ Mal Fem };
@NHT::races   = qw{ Hum Orc Gno Elf Dwa };
@NHT::alignments = qw{ Law Neu Cha };
@NHT::conducts = qw{ 
	foodless
	vegan
	vegetarian
	atheist
	weaponless
	pacifist
	illiterate
	polypileless
	polyselfless
	wishless
	artifact_wishless
	genocideless
};
@NHT::achievements = qw{
	got_bell
	entered_gehennom
    got_candelabrum
	got_book
	did_invocation
	got_amulet
	reached_elemental
	reached_astral
 	ascended
	did_mines
	did_sokoban
	killed_medusa
};
@NHT::stars = qw{
    dilithium platinum gold silver bronze steel 
    brass copper zinc iron lead plastic
};
@NHT::montys = qw{ full_monty grand_slam hat_trick double_top birdie };

=head1 NAME

NHT - Nethack Tournament

=head1 SYNOPSIS

Based on a scores.xlogfile, assemble statistics about a tournament and its 
players and clans.

=cut


=head1 METHODS

  my $nht = NHT->new(%args); # loads 
  $nht->reload;              # reloads all data and trophies
  $nht->players;             # returns arrayref of player names
  $nht->games;               # returns arrayref of all games
  $nht->games($player);      # returns arrayref of one player's games,
                             # sorted in chronological order
  $nht->trophies;            # returns arrayref of trophy names
  $nht->trophy($trophy);     # returns arrayref of sorted trophy results
  $nht->roles;               # returns arrayref of role names
  $nht->role($role);         # returns arrayref of games within a role,
                             # sorted highest scores first
  $nht->races;               # returns arrayref of race names
  $nht->race($race);         # returns arrayref of games within a race, 
                             # sorted highest scores first
  $nht->ascenders;           # returns players who ascended

=cut


#### heere begynneth the API

sub new {
  my ($class, %args) = @_;
  
  my $self = { args => \%args };
  bless $self, $class;

  return $self->init(%args);
}

sub reload {
  my ($self) = @_;
  $self->debug("Reloading everything...");
  return $self->init( $self->{args} )->debug("Done reloading everything.");
}

sub players {
  my ($self) = @_;
  my @players =  keys %{$self->{PLAYER}};
  return \@players;
}

sub games {
  my ($self, $player) = @_;
  my $games_ref;
  
  if ($player) {
    $games_ref = $self->{PLAYER}{$player} || [];
  }
  else {
    $games_ref = $self->{GAMES} || [];
  }
  
  my @games = grep { $_->{name} } @$games_ref;
  return \@games;
}

sub trophy {
  my ($self, $trophy) = @_;
  return $self->{TROPHY}{$trophy};
}

sub trophies {
  my ($self) = @_;
  my @trophies = keys %{$self->{TROPHY}};
  return \@trophies;
}

sub high_scores {
  my ($self) = @_;
  return $self->{HIGHSCORES};
}

sub roles { 
  my ($self) = @_;
  my @roles = keys %{ $self->{ROLE} };
  return\@roles;
}

sub role { 
  my ($self, $role) = @_;
  return $self->{ROLE}{$role};
}

sub ascensions {
  my ($self) = @_;
  return $self->{ASCENSIONS};
}

sub race { 
  my ($self, $race) = @_;
  return $self->{RACE}{$race};
}

sub races {
  my ($self) = @_;
  my @races = keys %{ $self->{RACE} };
  return \@races;
}

sub ascenders { 
	my ($self) = @_;
	my @asc = keys %{ $self->{ASCENDERS} };
	return \@asc;
}


### heere endyth the API



sub init {
  my ($self, %args) = @_;
  
  $self->{DEBUG} = $args{debug}||$args{debug_loud} ? 1 : 0;
  $self->{DEBUG_LOUD} = $args{debug_loud} ? 1 : 0;

  die $! unless $self->load_trophies;
  die $! unless $self->load_xlogfile(%args);
  die $! unless $self->compute_stats;

  return $self;
}

sub debug {
  my ($self, @args) = @_;
  return $self unless $self->{DEBUG};
  printf STDERR @args;
  printf STDERR "\n";
  return $self;
}
sub debug_loud {
  my ($self, @args) = @_;
  return $self unless $self->{DEBUG_LOUD};
  return $self->debug("*** ", @args);
}

## returns undef on failure
sub load_xlogfile {
  my ($self, %args) = @_;
  
  $self->debug("Loading xlogfile...");

  unless ($args{xlogfile} && -r $args{xlogfile}) {
    $args{xlogfile} ||= '/tmp/scores.xlogfile';

    my @cmd_args = ('-o', $args{xlogfile}, $args{xlogfile_url});
    my $rv = system('/usr/bin/env', 'curl', @cmd_args); # try curl
    $rv = $rv >> 8; 
    unless ($rv == 0) {
      $rv = system('/usr/bin/env', 'wget', @cmd_args); # curl fail, try wget
      $rv = $rv >> 8;
      return undef unless $rv == 0; # bail if we're double-screwed
    }
  }

  $self->{XLOG} = {};
  open XLOG, '<', $args{xlogfile} or die $!; # should not happen
  while (<XLOG>) {
    chomp;
    my ($id, $stats_str) = /^(\d\S+)\s+(.+)$/ or next;
    my %stats = split /[:=]/, $stats_str;
    $self->log_game($id, %stats);
  }
  close XLOG;

  return $self->debug("Done loading xlogfile.");
}




sub log_game {
  my ($self, $id, %stats) = @_;
  
  return unless $id && defined $stats{points};

  $self->debug_loud("Loading game $id");

  sub unpack_field {
    my ($stats, $field, @flags) = @_;
    my $bitfield = hex $stats->{$field};
    my $i=0;
    my $bits_set=0;
    my %out;
    
    for (@flags) {
      $bits_set += $out{$_} = ($bitfield & 1<<$i++) ? 1 : 0 ;
    }
    $out{$field} = $bits_set;

    return %out;
  }
 

  my $game = { 
  	game_id         => $id, 
  	trickery        => $stats{death}=~/trickery$/ ? 1 : 0,
	  realtime_hms    => realtime_hms($stats{realtime}),
	  starttime_date  => date($stats{starttime} - 3600*3),
    endtime_date    => date($stats{endtime} - 3600*3),
	$stats{role}    => 1,
	$stats{race}    => 1,
	$stats{gender0} => 1,
	$stats{align0}  => 1,
	%stats,
	unpack_field(\%stats, 'conduct', @NHT::conducts),
	unpack_field(\%stats, 'achieve', @NHT::achievements),
  };
  
  #$game->{json} = JSON::Any->encode($game);

  my $player = $stats{name};
  return unless $game->{name};
  
  ## insure against double-logging
  return if defined $self->{GAME}{$id};

  ## autovivification is awesome.  eat shit Ruby and Python
  $self->{GAME}{$id} = $game;
  push @{ $self->{GAMES }                }, $game;
  push @{ $self->{PLAYER}{$game->{name}} }, $game;
  push @{ $self->{ ROLE }{$game->{role}} }, $game;
  push @{ $self->{ RACE }{$game->{race}} }, $game;
  push @{ $self->{ASCENSIONS} }, $game if $game->{ascended};
  $self->{ASCENDERS}{ $game->{name} }++ if $game->{ascended};
}

sub realtime_hms {
	my ($time) = @_;

	my ($h, $m, $s);
	$h = int $time/3600;
	$time -= $h * 3600;

	$m = int $time/60;
  $time -= $m * 60;

	$s = $time;

	return sprintf "%d:%.2d:%.2d", $h, $m, $s;
}

sub date {
	my ($time) = @_;

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);

	return sprintf "%d/%.2d %.2d:%.2d:%.2d", $mon+1, $mday, $hour, $min, $sec;
}

=head1 INTERNAL DATA STRUCTURE 

This is what the internal data structure ultimately looks like:

  $self->{HIGHSCORES} = [ list of $game, highest scores first ]
  $self->{ASCENSIONS} = [ list of ascended $game, highest scores first ]
  $self->{ASCENDERS} =  { player_who_ascended => number_of_ascensions, ... }
  $self->{PLAYER}{ $game->{name} } = [ list of $game, chronological order ]
  $self->{ROLE}  { $game->{role} } = [ list of $game, highest scores first ]
  $self->{RACE}  { $game->{race} } = [ list of $game, highest scores first ]
  $self->{GAME}  { $game->{id}   } = $game
  $self->{TROPHY}{ $trophy_name  } = [ list of trophy results, winners first ]
  $self->{GAMES} = [ list of $game, chronological order ]

THIS IS NOT AN API.  Use the provided methods to access this data.

=cut


sub compute_stats {
  my ($self) = @_;
  
  $self->debug("Computing stats...");
  
  sub highscore { $b->{points} <=> $a->{points} }
  
  $self->debug("  sorting roles");
  for my $role (@NHT::roles) {
    $self->{ROLE}{$role} = [ sort highscore @{ $self->{ROLE}{$role} || [] } ];
  }
  
  $self->debug("  sorting ascensions");
  $self->{ASCENSIONS} = [ sort highscore @{ $self->{ASCENSIONS} || [] } ];

  $self->debug("  sorting all games");
  $self->{HIGHSCORES} = [ sort highscore @{ $self->{GAMES} || [] } ];

  ## run trophy code
  for my $trophy (@{ $self->{TROPHIES} }) {
    $self->debug("  computing results for trophy: $trophy->{name}");
    
    my $results = $trophy->{results}->($self);
    if (ref $results eq 'HASH') {
      while (my ($tname, $tresults) = each %$results) {
        $self->{TROPHY}{$tname} = $tresults;
      }
    }
    else {
        $self->{TROPHY}{ $trophy->{name} } = $trophy->{results}->($self);
    }
  }
  return $self->debug("Done computing stats.");
}


sub load_trophies {
  my ($self) = @_;

  $self->debug("Loading trophies...");
  
  $self->{TROPHIES} = NHT::Trophy->get_trophies;

  return $self->debug("Done loading trophies.");
}



33 + 1/3;



=head1 AUTHOR 

pete gamache, gamache@#$!#$gmail.com.  

=head1 LICENSE

8=====D

=head1 SOLDIER ANTS

I do not like them.

=cut 

