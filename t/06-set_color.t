#!/usr/bin/perl
use Test::More tests => 3;

BEGIN {
  use_ok('Term::ExtendedColor');
}

use Term::ExtendedColor;
use Data::Dumper;
$Data::Dumper::Terse      = 1;
$Data::Dumper::Indent     = 1;
$Data::Dumper::Useqq      = 1;
$Data::Dumper::Deparse    = 1;
$Data::Dumper::Quotekeys  = 0;
$Data::Dumper::Sortkeys   = 1;


# Needed, or else the return string will be eaten and
# we will be comparing ''

my $ansi = Dumper set_color(0, 'ffff00');
$ansi =~ s/^"(.+)"\n$/$1/;
is($ansi, '\e]4;0;rgb:ff/ff/00\e\\\\', 'set_color index 0');


my $ext = Dumper set_color(33, 'ff0000');
$ext =~ s/^"(.+)"\n$/$1/;
is($ext, '\e]4;33;rgb:ff/00/00\e\\\\', 'set_color index 33');
