#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

eval "use Test::Synopsis"; ## no critic

plan skip_all => 'Test::Synopsis required for testing synopsis' if $@;

all_synopsis_ok()
