package App::Depentree::Lookuper::Local;

use strict;
use warnings;

use Config;
use Module::CoreList ();
use Class::Load      ();

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{lib} = $params{lib} // 'local';

    return $self;
}

sub lookup {
    my $self = shift;
    my ($prereqs) = @_;

    my @OLD_INC = @INC;

    if (my $lib = $self->{lib}) {
        my @lib = split /,|\:/, $lib;

        foreach my $path (@lib) {
            if (-d "$path/lib/perl5") {
                unshift @INC, "$path/lib/perl5";
                unshift @INC, "$path/lib/perl5/$Config{archname}";
            }
            else {
                unshift @INC, $path;
            }
        }
    }

    my @modules;
  PREREQ: foreach my $prereq (@$prereqs) {
        next if $prereq eq 'perl';
        next if Module::CoreList::is_core($prereq);

        Class::Load::try_load_class($prereq) or do {
            warn "Can't load '$prereq': $@\n";
            next PREREQ;
        };

        my $version = $prereq->VERSION;

        push @modules, { module => $prereq, version => $version };
    }

    @INC = @OLD_INC;

    return \@modules;
}

1;
