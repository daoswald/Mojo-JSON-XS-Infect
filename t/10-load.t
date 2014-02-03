#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;


use_ok 'Mojo::JSON::XS::Infect', 'j';


# We ask for a Mojo::JSON object, but want a JSON::XS object.
my $o = Mojo::JSON->new;
isa_ok $o, 'Mojo::JSON';


# Object methods
can_ok $o, qw( encode decode true false error );

# Class methods
can_ok 'Mojo::JSON', qw( j new );

# Exports

can_ok __PACKAGE__, qw( j );


done_testing();
