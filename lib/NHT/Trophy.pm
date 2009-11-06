package NHT::Trophy;
use strict;
use warnings;

## somewhat crude auto-discovery of trophy modules
sub get_trophies {
  my @trophies;

  use Data::Dumper;

  for my $libdir (@INC) {
    for my $file (<$libdir/NHT/Trophy/*>) {
      next unless $file =~ m|NHT/Trophy/(.+)\.pm$|;
      
      my $pkgname = "NHT::Trophy::$1";
      my $trophy = {};      
      eval qq{
	  		use $pkgname;
	  		\$trophy->{name}    = $pkgname->name();
	  		\$trophy->{results} = sub { $pkgname->results(\@_) };
      };
      if ($@) {
	die "Trophy load failed: $pkgname: $@";
      }
      else {
	push @trophies, $trophy;
      }
    }
  }

  return \@trophies;
}


555;
