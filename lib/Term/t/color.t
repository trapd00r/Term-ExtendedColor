#!/usr/bin/perl
use Test::More tests => 8;

BEGIN {
  use_ok('Term::ExtendedColor');
}

use Term::ExtendedColor;

my $green_fg = fg('green1', 'foo');
is($green_fg, "\e[38;5;156mfoo\e[38;0m", 'FG - green1 - autoreset OFF');

my $green_bg = bg('green1', 'foo');
is($green_bg, "\e[48;5;156mfoo\e[38;0m", 'BG - green1 - autoreset OFF');

my $bold_fg = fg('bold', 'foo');
is($bold_fg, "\e[38;1mfoo\e[38;0m", 'FG - bold - autoreset OFF');

my $bold_bg = bg('bold', 'foo');
is($bold_bg, "\e[48;1mfoo\e[38;0m", 'BG - bold - autoreset OFF');

my $reset = clear();
is($reset, "\e[38;0m", 'reset to defaults');

Term::ExtendedColor::autoreset(0);
my $red_fg = fg('red1', 'foo');
is($red_fg, "\e[38;5;196mfoo", 'FG - red - autoreset ON');

my $red_bg = bg('red1', 'foo');
is($red_bg, "\e[48;5;196mfoo", 'BG - red - autoreset ON');
