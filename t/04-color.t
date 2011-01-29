#!/usr/bin/perl
use Test::More tests => 18;
use Term::ExtendedColor ':attributes';


is(      bold(12), "\e[38;1m12\e[m", 'bold()');
is(    italic(12), "\e[38;3m12\e[m", 'italic()');
is(   inverse(12), "\e[38;7m12\e[m", 'inverse()');
is( underline(12), "\e[38;4m12\e[m", 'underline()');


is(fg(0, 0), "\e[38;5;0m0\e[m", 'fg(0, 0) OK');

my $green_fg = fg('green1', 'foo');
is($green_fg, "\e[38;5;156mfoo\e[m", 'FG - green1 - autoreset OFF');

my $green_bg = bg('green1', 'foo');
is($green_bg, "\e[48;5;156mfoo\e[m", 'BG - green1 - autoreset OFF');

my $bold_fg = fg('bold', 'foo');
is($bold_fg, "\e[38;1mfoo\e[m", 'FG - bold - autoreset OFF');

my $bold_bg = bg('bold', 'foo');
is($bold_bg, "\e[48;1mfoo\e[m", 'BG - bold - autoreset OFF');

my $reset = clear();
is($reset, "\e[m", 'reset to defaults');

my $bold_green = fg('bold', fg('green1'));
is($bold_green, "\e[38;1m\e[38;5;156m", 'BOLD GREEN foreground');

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
is($fg_no_arg, "\e[m", 'fg() sets all attributes to the default');

my $bg_no_arg = bg();
is($bg_no_arg, "\e[m", 'bg() sets all attributes to the default');
