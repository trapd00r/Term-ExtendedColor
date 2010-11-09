package Term::ExtendedColor;

$VERSION = '0.10';

require Exporter;
@ISA = 'Exporter';
our @EXPORT = qw(c get_colors);
our @EXPORT_OK = qw(autoreset);

use Data::Dumper::Concise;
use Carp;

our $AUTORESET = 1;

my $fg = "\e[38;";
my $bg = "\e[48;";

my $end;

sub autoreset {
  $AUTORESET = shift;
  if($AUTORESET > 0) {
    $end = "\e[0m";
  }
  else {
    $end = '';
  }
}


my %color_names = (
  # light .. dark
  red1    => '5;196',
  red2    => '5;160',
  red3    => '5;124',
  red4    => '5;088',
  red5    => '5;052',

  green1  => '5;156',
  green2  => '5;155',
  green3  => '5;154',
  green4  => '5;148',
  green5  => '5;118',
  green6  => '5;112',
  green7  => '5;082',
  green8  => '5;076',
  green9  => '5;040',
  green10 => '5;046',
  green11 => '5;106',
  green12 => '5;100',

  blue1   => '5;39',
  blue2   => '5;38',
  blue3   => '5;33',
  blue4   => '5;32',
  blue5   => '5;31',
  blue6   => '5;27',
  blue7   => '5;26',
  blue8   => '5;25',
  blue9   => '5;21',
  blue10  => '5;20',
  blue11  => '5;19',
  blue12  => '5;18',
  blue13  => '5;17',

  yellow1 => '5;184',
  yellow2 => '5;220',
  yellow3 => '5;190',
  yellow4 => '5;226',
  yellow5 => '5;227',

  orange1 => '5;214',
  orange2 => '5;178',
  orange3 => '5;172',
  orange4 => '5;208',
  orange5 => '5;202',
  orange6 => '5;166',
  orange7 => '5;130',

  grey1   => '5;255',
  grey2   => '5;254',
  grey3   => '5;253',
  grey4   => '5;252',
  grey5   => '5;251',
  grey6   => '5;250',
  grey7   => '5;249',
  grey8   => '5;248',
  grey9   => '5;247',
  grey10  => '5;246',
  grey11  => '5;245',
  grey12  => '5;244',
  grey12  => '5;243',
  grey12  => '5;242',
  grey12  => '5;241',
  grey12  => '5;240',
  grey12  => '5;239',
  grey12  => '5;238',
  grey12  => '5;237',
  grey12  => '5;236',
  grey12  => '5;235',
  grey12  => '5;234',
  grey12  => '5;233',
  grey12  => '5;232',

  cerise1 => '5;197',
  cerise2 => '5;161',
  cerise3 => '5;125',

  reset     => '0',
  clear     => '0',
  bold      => '1',
  italic    => '3',
  underline => '4',
  blink     => '5',
  reverse   => '7',
);


sub c {
  my $color_str = shift;
  my @data = @_;
  return @data if(!defined($color_str));

  if(!defined($color_names{$color_str})) {
    return(@data);
    #croak("$color_str is not a valid name\n");
  }

  if(!(@data)) {
    return("$fg$color_names{$color_str}m");
  }


  @data = map{ "$fg$color_names{$color_str}m$_$end" } @data;
  #print Dumper \@data;
  return @data;
}

sub get_colors {
  return(\%color_names);
}





sub color_reset {
  return("\e[0m");
}

1;

=pod

=head1 NAME

  Term::ExtendedColor - Access the extended colorset in UNIX systems

=head1 SYNOPSIS

  use Term::ExtendedColor; # c(), get_colors() imported by default

  print c 'green10', "this is dark green\n";
  print c('red1', "this is bright red\n");

  Term::ExtendedColor::autoreset(0); # Turn off autoreset
  print c 'cerise2', "This is cerize...\n";
  print c 'bold', "... that turns into bold cerise\n\n";

  print c('reset');

  Term::ExtendedColor::autoreset(1); # Make sure to turn autoreset on again

  # Print all attributes
  my $colors = get_colors();

  for my $attr(sort(keys(%{$colors}))) {
    print c $attr, $attr, "\n" unless($colors->{$attr} =~ /^\d+$/);
  }

  print c('bold', c('blue2', "> Non-color attributes:\n"));
  for(qw(italic underline blink reverse bold)) {
    print c $_, "$_\n";
  }

=head1 DESCRIPTION

c()
  expects a string with an attribute attached to it as its first argument,
  and optionally any number of additional strings which the operation will be
  performed upon.
  If the internal $AUTORESET variabe is non-zero (default), the list of strings
  will be mapped with the attribute in front and the 'reset' attribute in the
  end. This is for convience, but the behaviour can be changed by calling
  Term::ExtendedColor::autoreset(0). Note that you will have to reset manually
  though, or else the set attributes will last after your script is finished,
  resulting in the prompt having strange colors.

  If you pass an invalid attribute, the original data will be returned
  unmodified.

get_colors()
  returns a hash reference with all available attributes.

=head1 SEE ALSO

  Term::ANSIColor

=head1 AUTHOR

Written by Magnus Woldrich

=head1 COPYRIGHT

Copyright 2010 Magnus Woldrich <magnus@trapd00r.se>. This program is free
software; you may redistribute it and/or modify it under the same terms as
Perl itself.

=cut




