use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Term::ExtendedColor',
    AUTHOR              => q{Magnus Woldrich <trapd00r@trapd00r.se>},
    VERSION_FROM        => 'lib/Term/ExtendedColor.pm',
    ABSTRACT_FROM       => 'lib/Term/ExtendedColor.pm',

    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),

    PL_FILES            => {},

    PREREQ_PM           => {
      'Test::More' =>     0,
    },

    EXE_FILES           => ['bin/uncolor',
                            'bin/colored_dmesg',
                            'bin/color_matrix',
                            'bin/set_single_color',
                            'bin/show_all_colors',
                            'bin/lookup',
                          ],

    MAN1PODS            => {
      'bin/uncolor'          => 'blib/man1/uncolor.1',
      'bin/colored_dmesg'    => 'blib/man1/colored_dmesg.1',
      'bin/set_single_color' => 'blib/man1/set_single_color.1',
    },

    MIN_PERL_VERSION    => 0,

    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Term-ExtendedColor-*' },
);
