use strict;
use warnings;
use Test::More;

use Mojo::JSON::XS::Infect;

my $o = Mojo::JSON->new;

$o->error("Hello");
is $o->error, 'Hello', 'Error sets and gets.';

done_testing();
