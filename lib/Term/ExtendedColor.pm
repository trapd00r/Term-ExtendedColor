package Term::ExtendedColor;

$VERSION = '0.10';

require Exporter;
@ISA = 'Exporter';
our @EXPORT = qw(uncolor get_colors set_color fg bg clear);

# We need to access the autoreset function by using the fully qualified name.
# If we try to import functions from @EXPORT_OK, the exported functions in
# @EXPORT doesnt get exported at all, for some reason.
# This is 'intended behaviour', according to #perl.
our @EXPORT_OK = qw(autoreset);

#use Data::Dumper::Concise;
use Carp;

our $AUTORESET = 1;

my $fg = "\e[38;";
my $bg = "\e[48;";

my($start, $end);

# There a no way to give these meaningful names.
# The X11 rgb names doesn't match, neither does
# any SVG or HTML colorset.
# Will probably add the colors hex values as another field.
# Will probably remap all of these colors, creating some kind of pattern.


#
#  blue1   => '5;39',
#  blue2   => '5;38',
#  blue3   => '5;33',
#  blue4   => '5;32',
#  blue5   => '5;31',
#  blue6   => '5;27',
#  blue7   => '5;26',
#  blue8   => '5;25',
#  blue9   => '5;21',
#  blue10  => '5;20',
#  blue11  => '5;19',
#  blue12  => '5;18',
#  blue13  => '5;17',
#
#  yellow1 => '5;184',
#  yellow2 => '5;220',
#  yellow3 => '5;190',
#  yellow4 => '5;226',
#  yellow5 => '5;227',
#
#  orange1 => '5;214',
#  orange2 => '5;178',
#  orange3 => '5;172',
#  orange4 => '5;208',
#  orange5 => '5;202',
#  orange6 => '5;166',
#  orange7 => '5;130',
#
#  cerise1 => '5;197',
#  cerise2 => '5;161',
#  cerise3 => '5;125',





my %color_names = (

  reset     => 0,
  clear     => 0,
  bold      => 1,
  italic    => 3,
  underline => 4,
  reverse   => 7,

  # light -> dark

  red1    => '5;196',     # => 'ff0000',
  red2    => '5;160',     # => 'd70000',
  red3    => '5;124',     # => 'af0000',
  red4    => '5;088',     # => '870000',
  red5    => '5;052',     # => '5f0000',

  green1  => '5;156',     # => 'afff87',
  green2  => '5;150',     # => 'afd787',
  green3  => '5;120',     # => '87ff87',
  green4  => '5;114',     # => '87d787',
  green5  => '5;084',     # => '5fff87',
  green6  => '5;078',     # => '5fd787',
  green7  => '5;155',     # => 'afff5f',
  green8  => '5;149',     # => 'afd75f',
  green9  => '5;119',     # => '87ff5f',
  green10 => '5;113',     # => '87d75f',
  green11 => '5;083',     # => '5fff5f',
  green12 => '5;077',     # => '5fd75f',
  green13 => '5;047',     # => '00ff5f',
  green14 => '5;041',     # => '00d75f',
  green15 => '5;118',     # => '87ff00',
  green16 => '5;112',     # => '87d700',
  green17 => '5;082',     # => '5fff00',
  green18 => '5;076',     # => '5fd700',
  green19 => '5;046',     # => '00ff00',
  green20 => '5;040',     # => '00d700',
  green21 => '5;034',     # => '00af00',
  green22 => '5;028',     # => '008700',
  green23 => '5;022',     # => '005f00',
  green24 => '5;107',     # => '87af5f',
  green25 => '5;071',     # => '5faf5f',
  green26 => '5;070',     # => '5faf00',
  green27 => '5;064',     # => '5f8700',
  green28 => '5;065',     # => '5f875f',
);


our $FG;
our $BG;

sub fg {
  # Call to fg() with zero args resets to defaults
  if(!@_) {
    return("\e[38;0m");
  }

  $FG = ($FG) ? 0 : 1;
  color(@_);
}

sub bg {
  if(!@_) {
    return("\e[38;0m");
  }

  $BG = ($BG) ? 0 : 1;
  color(@_);
}


sub color {
  my $color_str = shift;
  my @data = @_;
  return @data if(!defined($color_str));

  if(!exists($color_names{$color_str})) {
    return(@data);
    #croak("$color_str is not a valid name\n");
  }

  ($start) = ($FG)        ? "\e[38;" : "\e[48;";
  ($end)   = ($AUTORESET) ? "\e[38;0m"  : '';

  if(!(@data)) {
    # Works just like the color() function in Term::ANSIColor
    return("$start$color_names{$color_str}m");
  }

  map{ $_ = "$start$color_names{$color_str}m$_$end" } @data;

  # Restore state
  ($FG, $BG) = (0, 0);
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
    croak("Invalid index: $index. Valid numbers are 0-255\n");
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

sub clear {
  if(!@_) {
    return("$fg$color_names{clear}m");
  }
}


sub autoreset {
  $AUTORESET = shift;
  ($end) = ($AUTORESET) ? "\e[38;0m" : '';
}

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
  my $first = set_color(0, ff0000); # Change the first ANSI color to red

  # Change the greyscale spectrum to a range from fef502 (yellow) to e70f30
  # (red)

  my $base = 'ffff00';
  for(232..255) { # Greyscale colors
    #  ff, ff, 00
    my($r, $g, $b) = $base =~ /(..)(..)(..)/;

    $r = hex($r); # 255
    $g = hex($g); # 255
    $b = hex($b); # 0

    $r -= 1;  # 254
    $g -= 10; # 245
    $b += 2;  # 2

    $r = sprintf("%.2x", $r);
    $g = sprintf("%.2x", $g);
    $b = sprintf("%.2x", $b);

    $base = $r . $g . $b;

    my $new = set_color($_, $base);
    print $new
  }




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
  resulting in the prompt looking funny.

  If you pass an invalid attribute, the original data will be returned
  unmodified.

uncolor()
  strips the input data from escape sequences.

set_color()
  change color index n value to color hex.

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


1;
