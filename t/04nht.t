#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'NHT' }

ok( my $nht = NHT->new(xlogfile => 'scores.xlogfile.txt'),
    'Create NHT object'
);

ok( scalar @{$nht->roles} == 13,
    'Should be 13 roles'
);

