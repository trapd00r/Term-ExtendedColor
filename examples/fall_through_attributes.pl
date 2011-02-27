#!/usr/bin/perl
# Demonstrates fall-through attributes

use strict;
use warnings FATAL => 'all';

use Term::ExtendedColor qw(:attributes);
Term::ExtendedColor::autoreset( 0 );

my $red    = fg('red1', 'Red');
my $green  = fg('green1', 'Green');

print "Text following $red is red until $green\n";
print 'Text is still green, ', bold('and now bold as well!'), "\n";

clear();

my $blue = bg('navyblue', 'Blue background ');
print $blue, fg('darkorange1', bold(', Bold, Orange foreground ')), "\n";

clear();

print underline('Underlined'), ' and ', italic('italic'), "\n";

clear();
