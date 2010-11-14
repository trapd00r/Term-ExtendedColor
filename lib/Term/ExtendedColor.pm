package Term::ExtendedColor;

$VERSION = '0.10';

require Exporter;
@ISA = 'Exporter';
our @EXPORT = qw(color uncolor get_colors set_color);

# We need to access the autoreset function by using the fully qualified name.
# If we try to import functions from @EXPORT_OK, the exported functions in
# @EXPORT doesnt get exported at all, for some reason.
# This is 'intended behaviour', according to #perl.
our @EXPORT_OK = qw(autoreset);

use Data::Dumper::Concise;
use Carp;

our $AUTORESET = 1;

my $fg = "\e[38;";
my $bg = "\e[48;";
my $end;

# There a no way to give these meaningful names.
# The X11 rgb names doesn't match, neither does
# any SVG or HTML colorset.
# Will probably add the colors hex values as another field.
# Will probably remap all of these colors, creating some kind of pattern.
my %color_names = (
  # from light to dark.
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
  grey13  => '5;243',
  grey14  => '5;242',
  grey15  => '5;241',
  grey16  => '5;240',
  grey17  => '5;239',
  grey18  => '5;238',
  grey19  => '5;237',
  grey20  => '5;236',
  grey21  => '5;235',
  grey22  => '5;234',
  grey23  => '5;233',
  grey24  => '5;232',

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

#my %colors = (
#  red1 => {
#    '5;196' => 'ff0000',
#  },
#  red2 => {
#    '5;160' => 'd70000',
#  },
#  red3 => {
#    '5;124' => 'af0000',
#  },
#  red4 => {
#    '5;088' => '870000',
#  },
#  red5 => {
#    '5;052' => '5f0000',
#  },
#);



sub color {
  my $color_str = shift;
  my @data = @_;
  return @data if(!defined($color_str));

  if(!defined($color_names{$color_str})) {
    #return(@data);
    croak("$color_str is not a valid name\n");
  }

  if(!(@data)) {
    return("$fg$color_names{$color_str}m");
  }

  map{ $_ = "$fg$color_names{$color_str}m$_$end" } @data;
  return(join('', @data)); # FIXME
}

sub uncolor {
  my @data = @_;
  return undef if(!@data);

  for(@data) {
    s/(?:\e|\033)\[[0-9]+(?:;[0-9]+)?(;[0-9]+)m//g;
    s/(?:\e|\033)\[[0-9]+m//g;
  }
  return(@data);
}

sub set_color {
  my $index = shift; # color no 8
  my $color = shift; # ff0000

  if(($index < 0) or ($index > 255)) {
    croak("Invalid index: $index\n");
  }
  if($color !~ /^([A-Fa-f0-9]{6}$)/) {
    croak("Invalid hex: $color\n");
  }

  my($r_hex, $g_hex, $b_hex) = $color =~ /(..)(..)(..)/g;
  return("\e]4;$index;rgb:$r_hex/$g_hex/$b_hex\e\\");
}


sub get_colors {
  return(\%color_names);
}

sub autoreset {
  $AUTORESET = shift;
  if($AUTORESET > 0) {
    $end = "\e[0m";
  }
  else {
    $end = '';
  }
}

sub color_reset {
  return("\e[0m");
}

1;

=pod

=head1 NAME

  Term::ExtendedColor - Color screen output using extended escape sequences

=head1 SYNOPSIS

  use Term::ExtendedColor; # color(), uncolor(), get_colors() imported

  print color 'green10', "this is dark green\n";
  print color('red1', "this is bright red\n");

  Term::ExtendedColor::autoreset(0); # Turn off autoreset
  print color 'cerise2', "This is cerize...\n";
  print color 'bold', "... that turns into bold cerise\n\n";

  print color('reset');

  Term::ExtendedColor::autoreset(1); # Make sure to turn autoreset on again

  # Print all attributes
  my $colors = get_colors();

  for my $attr(sort(keys(%{$colors}))) {
    print color $attr, $attr, "\n" unless($colors->{$attr} =~ /^\d+$/);
  }

  print color('bold', color('blue2', "> Non-color attributes:\n"));
  for(qw(italic underline blink reverse bold)) {
    print color $_, "$_\n";
  }

  # Change some colors
  my $first = set_color(0, ff0000);
  my $new_


=head1 DESCRIPTION

color()
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

uncolor()
  strips the input data from escape sequences.

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




