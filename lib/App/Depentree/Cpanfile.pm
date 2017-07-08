package App::Depentree::Cpanfile;

use strict;
use warnings;

use Module::CPANfile;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub parse {
    my $self = shift;
    my ($file) = @_;

    my $cpanfile = Module::CPANfile->load($file);

    my $prereqs = $cpanfile->prereqs->as_string_hash;

    my @modules;
    foreach my $phase (keys %$prereqs) {
        next unless $phase eq 'runtime';

        foreach my $type (keys %{ $prereqs->{$phase} }) {
            next unless $type eq 'requires';

            push @modules, keys %{ $prereqs->{$phase}->{$type} };
        }
    }

    return @modules;
}

1;
