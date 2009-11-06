#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

use lib qw(lib);

use NHT;

my $nht = NHT->new(xlogfile => 'scores.xlogfile.2009', debug => 1);


for (qw//) { # qw/ birdie hat_trick /) { #($nht->trophies) {
  print "$_ results:\n";
  print Dumper [ @{$nht->trophy($_)}[0..4] ];
}

print Dumper [ @{ $nht->trophy('underperformers') }[0..4] ];


