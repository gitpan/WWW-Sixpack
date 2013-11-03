use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'WWW::Sixpack',
    AUTHOR           => q{Menno Blom <blom@cpan.org>},
    VERSION_FROM     => 'lib/WWW/Sixpack.pm',
    ABSTRACT_FROM    => 'lib/WWW/Sixpack.pm',
    LICENSE          => 'Perl_5',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Exception' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
        'Carp'          => 0,
        'Data::UUID'    => 0,
        'JSON::Any'     => 0,
        'LWP::UserAgent'=> 0,
        'URI'           => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WWW-Sixpack-*' },

    META_MERGE => {
        resources => {
            repository => 'https://github.com/b10m/p5-WWW-Sixpack',
        },
    },

);
