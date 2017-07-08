package App::Depentree;

use strict;
use warnings;

use Config;
use Module::CoreList;
use Class::Load ();
use File::Spec;
use File::chdir;
use App::Depentree::Cpanfile;
use App::Depentree::Dzil;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{root} = $params{root};
    $self->{lib}  = $params{lib};

    return $self;
}

sub venga {
    my $self = shift;

    local $CWD = $self->{root};

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

    my @prereqs = $self->parse_prereqs;

    my %modules;
  PREREQ: foreach my $prereq (@prereqs) {
        next if $prereq eq 'perl';
        next if Module::CoreList::is_core($prereq);

        Class::Load::try_load_class($prereq) or do {
            warn "Can't load '$prereq': $@\n";
            next PREREQ;
        };

        my $version = $prereq->VERSION;

        $modules{$prereq} = $version;
    }

    @INC = @OLD_INC;

    return \%modules;
}

sub parse_prereqs {
    my $self = shift;

    my %files = (
        cpanfile => 'cpanfile',
        dzil     => 'dist.ini'
    );

    foreach my $type (keys %files) {
        if (-f $files{$type}) {
            my $parser = $self->_build_parser($type);

            die "Unknown parser $parser\n" unless $parser;

            return $parser->parse($files{$type});
        }
    }

    die "ERROR: Can't detect dependencies\n";
}

sub _build_parser {
    my $self = shift;
    my ($parser) = @_;

    if ($parser eq 'cpanfile') {
        return App::Depentree::Cpanfile->new;
    }
    elsif ($parser eq 'dzil') {
        return App::Depentree::Dzil->new;
    }

    return;
}

1;
