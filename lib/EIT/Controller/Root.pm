package EIT::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use NHT;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

EIT::Controller::Root - Root Controller for EIT

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub login : Local {
  my ($self, $c) = @_;
  my ($user, $pass) = @{$c->req->params}{qw/username password/};
  
  # get ready for some cheapo authentication
  my $cmd = 'lynx -source http://nethack.devnull.net/tournament/login.shtml?' . 
  	'action=login&name=$name';
}

sub begin :Private {
  my ($self, $c) = @_;
  $c->stash->{year} = $c->model('NHT')->year;
}


sub year :Regex('^(\d\d\d\d)/(.+)') {
  my ($self, $c) = @_;
  $c->stash->{year} = $c->req->captures->[0];
  $c->forward( $c->req->captures->[1] );
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{trophies} = $c->model('NHT')->nht->trophies;
    for my $t (@{ $c->stash->{trophies} }) {
      $c->stash->{trophy_results}{$t} = $c->model('NHT')->nht->trophy($t);
    }
    
    $c->stash->{stars} = \@NHT::stars;
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}


sub player :Path('player') Args(1) {
  my ($self, $c, $player) = @_;
  
  if ($player) {
    $c->stash->{player}     = $player;
    $c->stash->{games}      = $c->model('NHT')->nht->games($player);
    $c->stash->{games_json} = JSON::Any->encode( $c->stash->{games} );
    $c->stash->{page_subtitle} = "$player";
  }
}


sub end : ActionClass('RenderView') {}


1;
