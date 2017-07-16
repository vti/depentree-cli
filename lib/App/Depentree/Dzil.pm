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

    my %prereqs;
    foreach my $section (keys %$dist_ini) {
        if ($section =~ m{^\s*Prereqs\s*(?:/\s*(?:Runtime|Test)Requires)?}) {
            %prereqs = (%prereqs, %{ $dist_ini->{$section} || {} });
        }
    }

    return keys %prereqs;
}

1;
