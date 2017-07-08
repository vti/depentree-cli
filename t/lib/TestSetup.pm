package TestSetup;

use strict;
use warnings;

sub create_file {
    my $class = shift;
    my ($path, $content) = @_;

    open my $fh, '>', $path or die $!;
    print $fh $content if defined $content;
    close $fh or die $!;

    return $path;
}

1;
