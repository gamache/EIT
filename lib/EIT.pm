package EIT;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/-Debug
                ConfigLoader
								Cache::FastMmap
								PageCache
                Static::Simple
                /;

our $VERSION = '0.1';

# Configure the application.
#
# Note that settings in eit.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'EIT' );


__PACKAGE__->config->{static} = {
    include_path => [ 
        __PACKAGE__->config->{root} . '/static'
    ],
};

__PACKAGE__->config->{'View::JSON'} = {
	expose_stash => 'json',
	allow_callback => 0,
};

# Start the application
__PACKAGE__->setup();


1;
