#!/usr/bin/perl -w

use ExtUtils::MakeMaker;
WriteMakefile(
    NAME                => 'Coy',
    VERSION_FROM        => 'lib/Coy.pm',
    PREREQ_PM           => {
        'Lingua::EN::Inflect'   => '1.89',
        'Test::More'            => '0.40',
    }
);
