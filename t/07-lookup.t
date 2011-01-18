#!/usr/bin/perl
use Test::More tests => 4;

use Term::ExtendedColor qw(lookup);

is(lookup(255), 'gray1', "lookup(255) returns grey'");
is(
  lookup("\e[38;5;197m"),
  'magenta25',
  'lookup(\e[38;5;197m) returns magenta25',
);

is(scalar(lookup([255, "\e[38;5;197m"])), 2, 'accepts arrayref and returns array');
is(lookup([197]), 'magenta25', 'lookup([197]) == magenta25');
