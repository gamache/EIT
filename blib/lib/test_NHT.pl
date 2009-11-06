#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

use lib qw(lib);

use NHT;

my $nht = NHT->new(debug => 1);

print Dumper [ @{$nht->trophy('most_ascensions')}[0..9] ];

print Dumper [ $nht->roles ];

