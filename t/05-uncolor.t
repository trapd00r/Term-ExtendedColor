#!/usr/bin/perl
use Test::More tests => 3;

BEGIN {
  use_ok('Term::ExtendedColor');
}


my(@colors, @attributes);

my $j = 0;
for(my $i = 0; $i< 255; ++$i) {
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


if('\e[' ~~ @colors or '\033[' ~~ @colors) {
  fail('uncolor(): Escape sequences present in colors array');
}
else {
  pass('uncolor(): No escape sequences left in colors array');
}
if('\e[' ~~ @attributes or '\033[' ~~ @attributes) {
  fail('uncolor(): Escape sequences present in attributes array');
}
else {
  pass('uncolor(): No escape sequences left in attributes array');
}
