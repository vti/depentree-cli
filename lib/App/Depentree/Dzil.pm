package App::Depentree::Dzil;

use strict;
use warnings;

use Config::Tiny;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub parse {
    my $self = shift;
    my ($file) = @_;

    my $dist_ini = Config::Tiny->read($file);

    my $prereqs = $dist_ini->{Prereqs};
    return () unless $prereqs && ref $prereqs eq 'HASH';

    return keys %$prereqs;
}

1;
