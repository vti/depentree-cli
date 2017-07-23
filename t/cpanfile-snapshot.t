use strict;
use warnings;
use lib 't/lib';

use Test::More;
use Test::TempDir::Tiny;
use TestSetup;

use_ok 'App::Depentree::Lookuper::CpanfileSnapshot';

subtest 'parse: parses cpanfile.snapshot' => sub {
    my $tempdir = tempdir();

    TestSetup->create_file("$tempdir/cpanfile.snapshot", <<'EOF');
# carton snapshot format: version 1.0
DISTRIBUTIONS
  AnyEvent-7.14
    pathname: M/ML/MLEHMANN/AnyEvent-7.14.tar.gz
    provides:
      AE undef
  YAML-Tiny-1.70
    pathname: E/ET/ETHER/YAML-Tiny-1.70.tar.gz
    provides:
      YAML::Tiny 1.70
    requirements:
      B 0
  common-sense-3.74
    pathname: M/ML/MLEHMANN/common-sense-3.74.tar.gz
    provides:
      common::sense 3.74
    requirements:
      ExtUtils::MakeMaker 0
EOF

    my $modules = _build(root => $tempdir)->lookup(['YAML::Tiny'], "$tempdir/cpanfile");

    is_deeply $modules, [ { distribution => 'YAML-Tiny', version => '1.70' } ];
};

done_testing;

sub _build {
    return App::Depentree::Lookuper::CpanfileSnapshot->new(@_);
}
