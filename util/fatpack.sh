#!/bin/sh

export PERL5LIB=".:$PERL5LIB"

cpanm -n -q --pp --installdeps . -L local --self-contained || exit 1

cpanm -n -q --pp App::FatPacker::Simple -L perl5 || exit 1
perl -Mlocal::lib=perl5 perl5/bin/fatpack-simple \
    --exclude Module::Build,Module::Build::Tiny \
    script/depentree || exit 1
