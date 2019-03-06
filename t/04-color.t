#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 24;
use Term::ExtendedColor ':attributes';


is(      bold(12), "\e[1m12\e[m", 'bold()');
is(    italic(12), "\e[3m12\e[m", 'italic()');
is(   inverse(12), "\e[7m12\e[m", 'inverse()');
is( underline(12), "\e[4m12\e[m", 'underline()');


is(fg(0, 0), "\e[38;5;0m0\e[m", 'fg(0, 0) OK');

my $green_fg = fg('green1', 'foo');
is($green_fg, "\e[38;5;156mfoo\e[m", 'FG - green1 - autoreset OFF');

my $green_bg = bg('green1', 'foo');
is($green_bg, "\e[48;5;156mfoo\e[m", 'BG - green1 - autoreset OFF');

my $bold_fg = fg('bold', 'foo');
is($bold_fg, "\e[1mfoo\e[m", 'FG - bold - autoreset OFF');

my $bold_bg = bg('bold', 'foo');
is($bold_bg, "\e[1mfoo\e[m", 'BG - bold - autoreset OFF');

my $reset = clear();
is($reset, "\e[m", 'reset to defaults');

my $bold_green = fg('bold', fg('green1'));
is($bold_green, "\e[1m\e[38;5;156m", 'BOLD GREEN foreground');

my @colors = fg('blue4', ['foo', 'bar']);

is(2, scalar(@colors), "fg(['foo', 'bar']) returns an array");
my $str = join("\n", @colors);
is(
  $str,
  "\e[38;5;039mfoo\e[m\n\e[38;5;039mbar\e[m",
  "fg('blue4', ['foo', 'bar']) successful"
);

Term::ExtendedColor::autoreset(0);

my $red_fg = fg('red1', 'foo');
is($red_fg, "\e[38;5;196mfoo", 'FG - red - autoreset ON');

my $red_bg = bg('red1', 'foo');
is($red_bg, "\e[48;5;196mfoo", 'BG - red - autoreset ON');

my $no_attr_str = fg('foo');
is($no_attr_str, 'foo', "fg('foo') returns 'foo'");

my $fg_no_arg = fg();
is($fg_no_arg, "\e[39m", 'fg() sets FOREGROUND to a default value');

my $bg_no_arg = bg();
is($bg_no_arg, "\e[49m", 'bg() sets BACKGROUND to a default value');

Term::ExtendedColor::autoreset(1);

my $raw_esc = fg('01;35', 'raw');
is($raw_esc, "\e[01;35mraw\e[m", 'raw esc OK');

my $raw_esc2 = bg('35;04', 'raw');
is($raw_esc2, "\e[35;04mraw\e[m", 'raw esc OK');

my $raw_esc3 = bg('35;4;1;3;7', 'attributes');
is($raw_esc3, "\e[35;4;1;3;7mattributes\e[m", 'raw esc ATTRIBUTES OK');

my $cursor_mv = fg('\e[20Bfoo', 'move cursor');
is($cursor_mv, 'move cursor', 'no cursor movement OK');

my $invert_bg = fg('\e[?5h', 'invert bg');
is($invert_bg, 'invert bg', 'no invert bg OK');

my $modify_index = fg('\e]4;197;rgb:ff/00/00\e\\', 'change index color');
is($modify_index, 'change index color', 'no change index color OK');
