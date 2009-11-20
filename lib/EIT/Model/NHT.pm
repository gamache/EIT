package EIT::Model::NHT;

use strict;
use warnings;
use parent qw/Catalyst::Model/;
use NHT;
use Data::Dumper;

sub ACCEPT_CONTEXT {
	my ($self, $c) = @_;
	return $self->nht($c->stash->{year});	
}

sub new {
  my $self = shift->next::method(@_);
  #warn Dumper $self;
  
  $self->{_nht} = {};

  my $year;
  for $year (keys %{ $self->{years} }) {
    #warn $year;
    $self->_nht->{$year} = NHT->new( %{ $self->{years}{$year} } );
  }

  $self->_nht->{default_year} = $self->{default_year} || $year;
  
  return $self;
}

sub _nht { shift->{_nht} }

sub year {
  my ($self, $year) = @_;
  $self->_nht->{default_year} = $year if $year;
  return $self->_nht->{default_year};
}

sub nht {
  my ($self, $year) = @_;
  return $self->_nht->{ $year || $self->year };
}

  

1;
