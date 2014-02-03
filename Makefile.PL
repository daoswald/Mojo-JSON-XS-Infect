## no critic (RCS,VERSION,may require interpolation)

use 5.008000;
use strict;
use warnings;
use ExtUtils::MakeMaker;

my $PREREQ_PM = {};

$PREREQ_PM->{'Exporter'}     = '5.59' if $] < 5.008004;

WriteMakefile(
  NAME              => 'Mojo::JSON::XS::Infect',
  AUTHOR            => q{David Oswald <davido [at] cpan [d.o.t] org>},
  VERSION_FROM      => 'lib/Mojo/JSON/XS/Infect.pm',
  ABSTRACT_FROM     => 'lib/Mojo/JSON/XS/Infect.pm',
  LICENSE           => 'artistic_2',
  MIN_PERL_VERSION  => '5.008000',
  PL_FILES          => {},
  PREREQ_PM         => $PREREQ_PM,
  META_MERGE => {
    'meta-spec'   => { version => 2 },
    resources     => {
      repository    => {
        type    => 'git',
        url     => 'https://github.com/daoswald/Mojo-JSON-XS-Infect.git',
        web     => 'https://github.com/daoswald/Mojo-JSON-XS-Infect',
      },
    },
    provides => {
      'Mojo::JSON::XS' => {
        file    => 'lib/Mojo/JSON/XS/Infect.pm',
        version => '0.01_001'
      },
    },
  },
  dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
  clean => { FILES    => 'Mojo-JSON-XS-Infect-*' },
);
