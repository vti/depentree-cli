# NAME

App::Depentree - Depentree.com command line

# SYNOPSIS

    $ cd my-perl-project/
    $ export DEPENTREE_TOKEN=98f9f5b5147058d71ce2ba09ae91cacfd79f53c0
    $ depentree --submit
    Submitted

    # or without installation

    curl 'https://raw.githubusercontent.com/vti/depentree-cli/master/depentree.fatpack' | perl

# DESCRIPTION

Collects your installed dependencies with versions and prints JSON object compatible for uploading to
[http://depentree.com](http://depentree.com).

The following files are detected: `cpanfile.snapshot`, `cpanfile`, `dzil.ini`.

# DEVELOPMENT

## Repository

    http://github.com/vti/depentree-cli

# AUTHOR

Viacheslav Tykhanovskyi, `vti@cpan.org`.

# COPYRIGHT AND LICENSE

Copyright (C) 2017, Viacheslav Tykhanovskyi

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.
