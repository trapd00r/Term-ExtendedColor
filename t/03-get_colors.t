#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 1;

use Term::ExtendedColor 'get_colors';

ok((ref(get_colors) eq 'HASH'), 'get_colors returns hash ref');
