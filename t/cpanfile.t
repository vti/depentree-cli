use strict;
use warnings;
use lib 't/lib';

use Test::More;
use Test::TempDir::Tiny;
use TestSetup;

use_ok 'App::Depentree::Cpanfile';

subtest 'parse: parses cpanfile' => sub {
    my $tempdir = tempdir();

    TestSetup->create_file("$tempdir/cpanfile", "requires 'Foo';");

    my @modules = _build()->parse("$tempdir/cpanfile");

    is_deeply \@modules, ['Foo'];
};

done_testing;

sub _build {
    return App::Depentree::Cpanfile->new;
}
