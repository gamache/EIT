package NHT::Trophy::RoleHighScores;
use NHT;

use warnings;
use strict;

sub name { "role_high_scores" }

sub results {
	my ($class, $nht) = @_;

    my %results;
    for my $role (@{$nht->roles}) {
        $results{$role} = [ 
            map { { player => $_->{name}, value => $_->{points}, game => $_ } }
                @{$nht->role($role)}
        ];
    }

	return \%results;
}


2.2222E09;