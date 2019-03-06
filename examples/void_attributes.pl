#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use autodie  qw(:all);

use Term::ExtendedColor qw(:attributes);

# demonstrates calling attr functions in void context this should look
# exactly the same in xterm, urxvt, vte...

my $bold = bold('this is bold');

$bold =~ s{(bold)}{bold()
                  . fg(196, underline('not'))
                  . ' '
                  . bold()
                  . $1
                  . ' /'
                  . italic('anymore')
                  . '/'}e;
print "$bold\n";

print "> No attributes here\n";

print join(' ',
  bold('bold'),
  italic('italic'),
  underline('underline'),
  inverse('inverse'),
), "\n";

print "> Term::ExtendedColor::autoreset OFF\n";

Term::ExtendedColor::autoreset(0);

print join(' ',
  bold('bold'),
  italic('italic'),
  underline('underline'),
  inverse('inverse'),
), "\n";
