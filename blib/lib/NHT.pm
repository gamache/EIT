use strict;
use warnings;

package NHT;
use NHT::Trophy;


=head1 NAME

NHT - Nethack Tournament

=head1 SYNOPSIS

Based on a scores.xlogfile, assemble statistics about a tournament and its 
players and clans.

=cut

my $XLOGFILE = "$ENV{HOME}/Code/EIT/scores.xlogfile.txt";
my $XLOGFILE_URL = 
  'http://nethack.devnull.net/archive/2008/scores.xlogfile.txt';

sub new {
  my ($class, %args) = @_;
  
  my $self = {};
  bless $self, $class;

  return $self->init(xlogfile => $XLOGFILE,
		     xlogfile_url => $XLOGFILE_URL, 
		     %args);
}

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
  return $self->debug("*** ", @_);
}

## returns undef on failure
sub load_xlogfile {
  my ($self, %args) = @_;
  
  $self->debug("Loading xlogfile...");

  unless (-f -r $args{xlogfile}) {
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
  
  $self->debug_loud("Loading game $id");

  my $game = { game_id => $id, 
	       ascended => $stats{death}=~/^ascended/ ? 1 : 0,
	       %stats };

  my $player = $stats{name};
  

  ## autovivification is awesome.  eat shit Ruby and Python
  $self->{GAME}{$id} = $game;
  push @{ $self->{GAMES} }, $game;
  push @{ $self->{PLAYER}{ $game->{name} } }, $game;
  push @{ $self->{ROLE}  { $game->{role} } }, $game;
  push @{ $self->{ASCENSIONS} }, $game if $game->{ascended};
}


=head1 INTERNAL DATA STRUCTURE 

This is what the internal data structure ultimately looks like:

  $self->{HIGHSCORES} = [ list of $game, highest scores first ]
  $self->{ASCENSIONS} = [ list of ascended $game, highest scores first ]
  $self->{PLAYER}{ $game->{name} } = [ list of $game, highest scores first ]
  $self->{ROLE}  { $game->{role} } = [ list of $game, highest scores first ]
  $self->{GAME}  { $game->{id}   } = $game
  $self->{TROPHY}{ $trophy_name  } = [ list of trophy results, 
                                        sorted "best or first first" ]
  $self->{GAMES} = [ list of $game ]

THIS IS NOT AN API.  Use the provided methods to access this data.

=cut


sub compute_stats {
  my ($self) = @_;
  
  $self->debug("Computing stats...");
  
  sub highscore { $b->{points} <=> $a->{points} }
  
  $self->debug("  sorting players and roles");
  for my $key1 (qw/PLAYERS ROLES/) {
    for my $key2 (keys %{$self->{key1}}) {
      $self->{$key1}{$key2} = [ sort highscore @{ $self->{$key1}{$key2} } ];
    }
  }

  $self->debug("  sorting ascensions");
  $self->{ASCENSIONS} = [ sort highscore @{ $self->{ASCENSIONS} } ];

  $self->debug("  sorting all games");
  $self->{HIGHSCORES} = [ sort highscore @{ $self->{GAMES} } ];

  ## run trophy code
  for my $trophy (@{ $self->{TROPHIES} }) {
    $self->debug("  computing results for trophy: $trophy->{name}");
    $self->{TROPHY}{ $trophy->{name} } = $trophy->{results}->($self);
  }

  return $self->debug("Done computing stats.");
}


sub load_trophies {
  my ($self) = @_;

  $self->debug("Loading trophies...");
  
  $self->{TROPHIES} = [ NHT::Trophy->get_trophies ];

  return $self->debug("Done loading trophies.");
}


=head1 API

  my $nht = NHT->new(%args);
  $nht->players;             # returns list or arrayref of player names
  $nht->games;               # returns list or arrayref of all games
  $nht->games($player);      # returns list or arrayref of one player's games
  $nht->trophies;            # returns list or arrayref of trophy names
  $nht->trophy($trophy);     # returns list or arrayref of trophy results
  $nht->roles;               # returns list or arrayref of role names
  $nht->role($role);         # returns list or arrayref of games within a role,
                             # sorted highest scores first

=cut


sub players {
  my ($self) = @_;
  my @players =  keys %{$self->{PLAYER}};
  return wantarray ? @players : \@players;
}

sub games {
  my ($self, $player) = @_;
  my $games;
  if ($player) {
    $games = $self->{PLAYER}{$player};
  }
  else {
    $games = $self->{GAMES};
  }

  return wantarray ? @$games : $games;
}

sub trophy {
  my ($self, $trophy) = @_;
  return wantarray? @{$self->{TROPHY}{$trophy}} : $self->{TROPHY}{$trophy};
}

sub trophies {
  my ($self) = @_;
  my @trophies = keys %{$self->{TROPHY}};
  return wantarray ? @trophies : \@trophies;
}

sub high_scores {
  my ($self) = @_;
  return wantarray ? @{$self->{HIGHSCORES}} : $self->{HIGHSCORES};
}

sub roles { 
  my ($self) = @_;
  my @roles =  keys %{$self->{ROLE}};
  return wantarray ? @roles : \@roles;
}

sub role { 
  my ($self, $role) = @_;
  my $games = $self->{ROLE}{$role};
  return wantarray ? @$games : $games;
}

33 + 1/3;
