#!/usr/bin/perl
# vim: ft=perl:fdm=marker:fmr=#<,#>:fen:et:sw=2:
use strict;
use warnings FATAL => 'all';
use autodie  qw(:all);

use Data::Dumper;

{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}

use Term::ExtendedColor qw(fg);

my $madness = fg('48;5;196;38;5;220;1;2;3;4;6;7;8',
                 '48;5;196;38;5;220;1;2;3;4;6;7;8'
                );

print Dumper $madness;
print "equals $madness\n";




__END__
