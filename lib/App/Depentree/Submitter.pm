package App::Depentree::Submitter;

use strict;
use warnings;

use HTTP::Tiny;
use JSON ();
use App::Depentree;

my $API_ENDPOINT = ($ENV{DEPENTREE_ADDRESS} || 'https://depentree.com') . '/submit_dependencies';

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{token}        = $params{token};
    $self->{dependencies} = $params{dependencies};

    return $self;
}

sub submit {
    my $self = shift;

    my $dependencies = JSON::encode_json($self->{dependencies});

    my $ua = $self->_build_ua;

    my $response;
    for my $i (1 .. 3) {
        $response = $ua->post_form(
            $API_ENDPOINT,
            {
                token        => $self->{token},
                dependencies => $dependencies
            }
        );

        last if $response->{success};

        last unless $response->{status} eq '599';

        warn "Retrying in ${i}s because of $response->{reason}: $response->{content}...\n";
        $self->_sleep($i);
    }

    if (!$response->{success}) {
        my $error = $response->{reason};

        if ($response->{status} eq '599') {
            $error .= ': ' . $response->{content};
        }

        die "Error: $error\n" unless $response->{success};
    }
}

sub _sleep { shift; sleep(@_) }

sub _build_ua {
    my $self = shift;

    my $class   = ref $self;
    my $version = App::Depentree->VERSION;

    return HTTP::Tiny->new(agent => "$class/$version ");
}

1;
