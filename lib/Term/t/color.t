#!/usr/bin/perl
use Test::More tests => 8;

BEGIN {
  use_ok('Term::ExtendedColor');
}

use Term::ExtendedColor;

my $green_fg = fg('green1', 'foo');
ok($green_fg eq "\e[38;5;156mfoo\e[38;0m", 'FG - green1 - autoreset OFF');

my $green_bg = bg('green1', 'foo');
ok($green_bg eq "\e[48;5;156mfoo\e[38;0m", 'BG - green1 - autoreset OFF');

my $bold_fg = fg('bold', 'foo');
ok($bold_fg eq "\e[38;1mfoo\e[38;0m", 'FG - bold - autoreset OFF');

my $bold_bg = bg('bold', 'foo');
ok($bold_bg eq "\e[48;1mfoo\e[38;0m", 'BG - bold - autoreset OFF');

my $reset = clear();
ok($reset eq "\e[38;0m", 'reset to defaults');

Term::ExtendedColor::autoreset(0);
my $red_fg = fg('red1', 'foo');
ok($red_fg eq "\e[38;5;196mfoo", 'FG - red - autoreset ON');

my $red_bg = bg('red1', 'foo');
ok($red_bg eq "\e[48;5;196mfoo", 'BG - red - autoreset ON');
