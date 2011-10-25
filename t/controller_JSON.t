use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'EIT' }
BEGIN { use_ok 'EIT::Controller::JSON' }

ok( request('/json')->is_success, 'Request should succeed' );


