package Mojo::JSON::XS::Infect;

use strict;
use warnings;

use JSON::XS;
use Mojo::ByteStream 'b';
use Carp;

BEGIN{
  if ( eval { my $o = Mojo::JSON->new; 1; } ) {
    croak 'Mojo::JSON::XS::Infect must be loaded before Mojo::JSON';
  }
  else {
    eval "use Mojo::JSON qw(j);";
  }
}

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw( j );


# Literal names
our $FALSE = JSON::XS::false;
our $TRUE  = JSON::XS::true;

# Byte order marks
my $BOM_RE = qr/
    (?:
    \357\273\277   # UTF-8
    |
    \377\376\0\0   # UTF-32LE
    |
    \0\0\376\377   # UTF-32BE
    |
    \376\377       # UTF-16BE
    |
    \377\376       # UTF-16LE
    )
/x;

# Unicode encoding detection
my $UTF_PATTERNS = {
    "\0\0\0[^\0]"    => 'UTF-32BE',
    "\0[^\0]\0[^\0]" => 'UTF-16BE',
    "[^\0]\0\0\0"    => 'UTF-32LE',
    "[^\0]\0[^\0]\0" => 'UTF-16LE'
};



{
#  no warnings qw( redefine );

  *Mojo::JSON::new = sub {
    my $class = shift;
    my $self  = bless {}, $class;
    $self->{_jsonxs} = JSON::XS->new->convert_blessed(1);
    return $self;
  };

  *Mojo::JSON::decode = sub {
    my ($self, $string) = @_;
    # Shortcut
    return unless length $string;

    # Cleanup
    $self->error(undef);

    # Remove BOM
    $string =~ s/^$BOM_RE//go;

    # Detect and decode unicode
    my $encoding = 'UTF-8';
    for my $pattern (keys %$UTF_PATTERNS) {
        if ($string =~ /^$pattern/) {
            $encoding = $UTF_PATTERNS->{$pattern};
            last;
        }
    }
    $string = b($string)->decode($encoding)->to_string;

    my $result;

    eval { $result = $self->{_jsonxs}->decode($string); };

    if ($@) {
        $self->error($string, $@);
        return;
    }

    return $result;
  };

  *Mojo::JSON::encode = sub {
    my ($self, $ref) = @_;

    my $string = $self->{_jsonxs}->encode($ref);
    $string =~ s!\x{2028}!\\u2028!gs;
    $string =~ s!\x{2029}!\\u2029!gs;

    # Unicode
    return b($string)->encode('UTF-8')->to_string;
  };



}

1;
