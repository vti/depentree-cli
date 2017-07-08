use strict;
use warnings;
use lib 't/lib';

use Test::More;
use Test::TempDir::Tiny;
use TestSetup;

use_ok 'App::Depentree::Dzil';

subtest 'parse: parses dzil.ini' => sub {
    my $tempdir = tempdir();

    TestSetup->create_file("$tempdir/dzil.ini", "[Prereqs]\nFoo = 1.0");

    my @modules = _build()->parse("$tempdir/dzil.ini");

    is_deeply \@modules, ['Foo'];
};

done_testing;

sub _build {
    return App::Depentree::Dzil->new;
}
