#!/usr/bin/perl
use Test::More tests => 2;

use Term::ExtendedColor;

is(lookup(255), 'gray1', "lookup(255) returns grey'");
is(
  lookup("\e[38;5;197m"),
  'magenta25',
  'lookup(\e[38;5;197m) returns magenta25',
);
