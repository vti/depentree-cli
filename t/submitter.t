use strict;
use warnings;

use Test::More;
use Test::MonkeyMock;

use Cwd qw(getcwd);
use JSON ();

use_ok 'App::Depentree::Submitter';

subtest 'submit: submits dependencies' => sub {
    my $ua = _mock_ua();

    my $submitter = _build(dependencies => [ { module => 'Foo::Bar', version => '1.2' } ], token => '123');
    $submitter->mock(_build_ua => sub { $ua });

    $submitter->submit;

    my ($url, $form) = $ua->mocked_call_args('post_form');

    is $form->{token}, '123';
    is_deeply JSON::decode_json($form->{dependencies}), [ { module => 'Foo::Bar', version => '1.2' } ];
};

subtest 'report: retries on internal exception' => sub {
    my $retries = 0;
    my $slept   = 0;
    my $ua      = _mock_ua(
        post_form => sub {
            $retries++;
            return { success => 0, status => 599, reason => 'Internal Exception', content => 'Timeout' };
        }
    );

    my $submitter = _build(dependencies => [], token => '123', sleep => sub { $slept += $_[1] });
    $submitter->mock(_build_ua => sub { $ua });

    local *STDERR;
    open STDERR, ">", \my $stderr;

    eval { $submitter->submit };
    like $@, qr/Internal Exception: Timeout/;

    is $retries,  3;
    is $slept,    6;
    like $stderr, qr/Retrying in 1s.*Retrying in 2s.*Retrying in 3s/ms;
};

subtest 'report: throws immediately on non internal exception' => sub {
    my $retries = 0;
    my $ua      = _mock_ua(
        post_form => sub { $retries++; return { success => 0, status => 404, reason => 'Not Found', content => '' } });

    my $submitter = _build(dependencies => [], token => '123');
    $submitter->mock(_build_ua => sub { $ua });

    eval { $submitter->submit };
    ok $@;

    is $retries, 1;
};

done_testing;

sub _mock_ua {
    my (%params) = @_;

    my $ua = Test::MonkeyMock->new;
    $ua->mock(post_form => $params{post_form} || sub { { success => 1 } });
    return $ua;
}

sub _build {
    my (%params) = @_;

    my $submitter = App::Depentree::Submitter->new(%params);

    $submitter = Test::MonkeyMock->new($submitter);
    $submitter->mock(_sleep => $params{sleep} || sub { });

    return $submitter;
}
