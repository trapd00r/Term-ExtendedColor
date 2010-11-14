#!/usr/bin/perl
use Test::More tests => 5;

BEGIN {
  use_ok('Term::ExtendedColor');
}

use Term::ExtendedColor;

my $blue1 = color('blue1', 'foo');
ok($blue1 eq "\e[38;5;39mfoo\e[38;0m", 'blue1 fg color');

my $bold = color('bold', 'bar');
ok($bold eq "\e[38;1mbar\e[38;0m", 'bold attribute');

my $reset = color('reset');
ok($reset eq "\e[38;0m", 'reset to defaults');

Term::ExtendedColor::autoreset(0);
my $red1 = color('red1', 'foo');
ok($red1 eq "\e[38;5;196mfoo", 'red1 fg color - no autoreset');
