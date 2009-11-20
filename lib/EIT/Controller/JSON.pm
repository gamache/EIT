package EIT::Controller::JSON;
use JSON::Any;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub end : Private {
	my ($self, $c) = @_;
	$c->forward('EIT::View::JSON');
}

sub player : LocalRegex('players?/(.+?)(\.json)?$') {
	my ($self, $c) = @_;

	my $player = $c->req->captures->[0];

	if ($player) {
		$c->stash->{json} = { 
#			player => {
				name => $player,
				games => $c->model('NHT')->games($player),
#			}
		};
	}
}

1;
