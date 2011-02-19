#!/usr/bin/perl
# test code for FIXME/BUG/TODO/XXX/NOTE labels

use strict;
use warnings;
use Test::More;

eval 'use Test::Fixme';    ## no critic
plan skip_all => 'Test::Fixme required' if $@;

run_tests(
  match          => qr/FIXME|BUG\b|XXX/,
  filename_match => qr/\.(pm)$/,
  where          => [ qw( lib ) ]
);

