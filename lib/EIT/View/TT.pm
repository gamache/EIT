package EIT::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
		    TEMPLATE_EXTENSION => '.tt',
		    INCLUDE_PATH => 'templates',
		    WRAPPER => 'wrapper.tt',
		    TIMER => 0,
);

=head1 NAME

EIT::View::TT - TT View for EIT

=head1 DESCRIPTION

TT View for EIT.

=head1 SEE ALSO

L<EIT>

=head1 AUTHOR

pete gamache

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
