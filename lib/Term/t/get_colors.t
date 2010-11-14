#!/usr/bin/perl
use Test::More tests => 2;

BEGIN {
  use_ok('Term::ExtendedColor');
}
use Term::ExtendedColor;

ok((ref(get_colors) eq 'HASH'), 'get_colors returns hash ref');
