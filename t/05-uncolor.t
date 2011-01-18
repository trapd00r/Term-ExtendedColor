#!/usr/bin/perl
use Test::More tests => 2;
use Term::ExtendedColor qw(uncolor get_colors);

my(@colors, @attributes);

my $j = 0;
for(my $i = 0; $i< 17; ++$i) {
  if($j % 2 == 0) {
    push(@colors, "\e[38;5;$i" . 'm' . 'This is in color' . "\e[0m");
  }
  else {
    push(@colors, "\033[38;5;$i" . 'm' . 'This is in color' . "\033[0m");
  }
  $j++;
}

$j = 0;
for(my $i = 0; $i<9; ++$i) {
  if($j % 2 == 0) {
    push(@attributes, "\e[$i" . 'm' . 'This is with attributes added' . "\e[0m");
  }
  else {
    push(@attributes, "\033[$i" . 'm' . 'This is with attributes added' . "\033[0m");
  }
}

@colors     = uncolor(@colors);
@attributes = uncolor(@attributes);

my $colors = get_colors();

#push(@colors, fg('red2', 'foobar'));

my $fail = 0;
for(@colors) {
  if($_ =~ /\e[38;[\d]+/) {
    $fail++;
  }
}
for(@attributes) {
  if($_ =~ /\e[48;[\d]+/) {
    $fail++;
  }
}

$fail
  ? fail("uncolor: color esc sequences not parsed correctly ($fail)")
  : pass("uncolor: color esc sequences parsed correctly")
;

use Data::Dumper;
$Data::Dumper::Terse     = 1;
$Data::Dumper::Indent    = 1;
$Data::Dumper::Useqq     = 1;
$Data::Dumper::Deparse   = 1;
$Data::Dumper::Quotekeys = 0;
$Data::Dumper::Sortkeys  = 1;

my $non_color = Dumper uncolor(
  "\e[2cNot \e[38;5;100;1mlegal\e[0m color esc sequences\e [0m"
);

$non_color =~ s/^"(.+)"\n$/$1/;
is($non_color,
  '\e[2cNot legal color esc sequences\e [0m',
  'uncolor does not remove non-color stuff'
);

