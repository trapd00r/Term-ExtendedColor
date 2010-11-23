#!/usr/bin/perl
use Test::More tests => 13;
use Term::ExtendedColor;

use Data::Dumper;
$Data::Dumper::Terse     = 1;
$Data::Dumper::Indent    = 1;
$Data::Dumper::Useqq     = 1;
$Data::Dumper::Deparse   = 1;
$Data::Dumper::Quotekeys = 0;
$Data::Dumper::Sortkeys  = 1;


my $green_fg = fg('green1', 'foo');
is($green_fg, "\e[38;5;156mfoo\e[0m", 'FG - green1 - autoreset OFF');

my $green_bg = bg('green1', 'foo');
is($green_bg, "\e[48;5;156mfoo\e[0m", 'BG - green1 - autoreset OFF');

my $bold_fg = fg('bold', 'foo');
is($bold_fg, "\e[38;1mfoo\e[0m", 'FG - bold - autoreset OFF');

my $bold_bg = bg('bold', 'foo');
is($bold_bg, "\e[48;1mfoo\e[0m", 'BG - bold - autoreset OFF');

my $reset = clear();
is($reset, "\e[0m", 'reset to defaults');

my $bold_green = fg('bold', fg('green1'));
is($bold_green, "\e[38;1m\e[38;5;156m", 'BOLD GREEN foreground');

my @colors = fg('blue4', ['foo', 'bar']);

is(2, scalar(@colors), "fg(['foo', 'bar']) returns an array");
my $str = join("\n", @colors);
is(
  $str,
  "\e[38;5;039mfoo\e[0m\n\e[38;5;039mbar\e[0m",
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
is($fg_no_arg, "\e[0m", 'fg() sets all attributes to the default');

my $bg_no_arg = bg();
is($bg_no_arg, "\e[0m", 'bg() sets all attributes to the default');
