package App::Depentree::Lookuper::CpanfileSnapshot;

use strict;
use warnings;

use File::Spec;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{root} = $params{root};

    return $self;
}

sub lookup {
    my $self = shift;
    my ($prereqs) = @_;

    my $root = $self->{root} // '.';

    open my $fh, '<', File::Spec->catfile($root, 'cpanfile.snapshot') or die $!;

    my $state = 'D';

    my @index;
    while (my $line = <$fh>) {
        chomp $line;

        if ($line =~ m/^\s{2}([^\s]+)-([^\-]+)$/) {
            push @index, {
                distribution => $1,
                version => $2
            };

            $state = 'D';
        }
        elsif ($line =~ m/\s{4}provides:/) {
            $state = 'P';
        }
        elsif ($state eq 'P' && $line =~ m/^\s{6}([^\s]+)\s+/) {
            push @{ $index[-1]->{provides} }, $1;
        }
        else {
            $state = 'D';
        }
    }

    close $fh;

    my %index;
    foreach my $index (@index) {
        foreach my $provides (@{ delete $index->{provides} || []}) {
            $index{$provides} = $index;
        }
    }

    my @modules;
    foreach my $prereq (@$prereqs) {
        next unless my $resolved = $index{$prereq};

        push @modules, {
            distribution => $resolved->{distribution},
            version => $resolved->{version},
        }
    }

    return \@modules;
}

1;
