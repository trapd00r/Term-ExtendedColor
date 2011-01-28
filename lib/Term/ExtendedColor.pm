package Term::ExtendedColor;
use strict;

BEGIN {
  use Exporter;
  use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

  $VERSION = '0.180';
  @ISA     = qw(Exporter);

  @EXPORT_OK = qw(
    uncolor
    get_colors
    lookup
    autoreset
    fg
    bg
    clear
    bold
    italic
    underline
    inverse
  );

  %EXPORT_TAGS = (
    attributes => [ qw(fg bg clear bold italic underline inverse) ],
  );
}

our $AUTORESET = 1;


# There a no way to give these meaningful names.
# The X11 rgb names doesn't match, neither does
# any SVG or HTML colorset.
# They are mapped from light to dark.

my %color_names = (

  reset     => 0,     clear      => 0,   normal => 0,
  bold      => 1,     bright     => 1,
  faint     => 2,
  italic    => 3,     cursive    => 3,
  underline => 4,     underscore => 4,

  # Blink: slow
  blink     => 5,

  # Blink: rapid (MS DOS ANSI.SYS, not widely supported)
  blink_ms  => 6,

  reverse   => 7,     inverse    => 7,   negative => 7,
  conceal   => 8,

  # Brightest to darkest color

  red1      => '5;196',     # => 'ff0000',
  red2      => '5;160',     # => 'd70000',
  red3      => '5;124',     # => 'af0000',
  red4      => '5;088',     # => '870000',
  red5      => '5;052',     # => '5f0000',

  green1    => '5;156',     # => 'afff87',
  green2    => '5;150',     # => 'afd787',
  green3    => '5;120',     # => '87ff87',
  green4    => '5;114',     # => '87d787',
  green5    => '5;084',     # => '5fff87',
  green6    => '5;078',     # => '5fd787',
  green7    => '5;155',     # => 'afff5f',
  green8    => '5;149',     # => 'afd75f',
  green9    => '5;119',     # => '87ff5f',
  green10   => '5;113',     # => '87d75f',
  green11   => '5;083',     # => '5fff5f',
  green12   => '5;077',     # => '5fd75f',
  green13   => '5;047',     # => '00ff5f',
  green14   => '5;041',     # => '00d75f',
  green15   => '5;118',     # => '87ff00',
  green16   => '5;112',     # => '87d700',
  green17   => '5;082',     # => '5fff00',
  green18   => '5;076',     # => '5fd700',
  green19   => '5;046',     # => '00ff00',
  green20   => '5;040',     # => '00d700',
  green21   => '5;034',     # => '00af00',
  green22   => '5;028',     # => '008700',
  green23   => '5;022',     # => '005f00',
  green24   => '5;107',     # => '87af5f',
  green25   => '5;071',     # => '5faf5f',
  green26   => '5;070',     # => '5faf00',
  green27   => '5;064',     # => '5f8700',
  green28   => '5;065',     # => '5f875f',

  blue1     => '5;075',
  blue2     => '5;074',
  blue3     => '5;073',
  blue4     => '5;039',
  blue5     => '5;038',
  blue6     => '5;037',
  blue7     => '5;033',
  blue8     => '5;032',
  blue9     => '5;031',
  blue10    => '5;027',
  blue11    => '5;026',
  blue12    => '5;025',
  blue13    => '5;021',
  blue14    => '5;020',
  blue15    => '5;019',
  blue16    => '5;018',
  blue17    => '5;017',

  yellow1   => '5;228',
  yellow2   => '5;222',
  yellow3   => '5;192',
  yellow4   => '5;186',
  yellow5   => '5;227',
  yellow6   => '5;221',
  yellow7   => '5;191',
  yellow8   => '5;185',
  yellow9   => '5;226',
  yellow10  => '5;220',
  yellow11  => '5;190',
  yellow12  => '5;184',
  yellow13  => '5;214',
  yellow14  => '5;178',
  yellow15  => '5;208',
  yellow16  => '5;172',
  yellow17  => '5;202',
  yellow18  => '5;166',

  magenta1  => '5;219',
  magenta2  => '5;183',
  magenta3  => '5;218',
  magenta4  => '5;182',
  magenta5  => '5;217',
  magenta6  => '5;181',
  magenta7  => '5;213',
  magenta8  => '5;177',
  magenta9  => '5;212',
  magenta10 => '5;176',
  magenta11 => '5;211',
  magenta12 => '5;175',
  magenta13 => '5;207',
  magenta14 => '5;171',
  magenta15 => '5;206',
  magenta16 => '5;170',
  magenta15 => '5;205',
  magenta16 => '5;169',
  magenta17 => '5;201',
  magenta18 => '5;165',
  magenta19 => '5;200',
  magenta20 => '5;164',
  magenta21 => '5;199',
  magenta22 => '5;163',
  magenta23 => '5;198',
  magenta24 => '5;162',
  magenta25 => '5;197',
  magenta26 => '5;161',

  gray1     => '5;255',
  gray2     => '5;254',
  gray3     => '5;253',
  gray4     => '5;252',
  gray5     => '5;251',
  gray6     => '5;250',
  gray7     => '5;249',
  gray8     => '5;248',
  gray9     => '5;247',
  gray10    => '5;246',
  gray11    => '5;245',
  gray12    => '5;244',
  gray13    => '5;243',
  gray14    => '5;242',
  gray15    => '5;241',
  gray16    => '5;240',
  gray17    => '5;239',
  gray18    => '5;238',
  gray19    => '5;237',
  gray20    => '5;236',
  gray21    => '5;235',
  gray22    => '5;234',
  gray23    => '5;233',
  gray24    => '5;232',

  purple1   => '5;147',
  purple2   => '5;146',
  purple3   => '5;145',
  purple4   => '5;141',
  purple5   => '5;140',
  purple6   => '5;139',
  purple7   => '5;135',
  purple8   => '5;134',
  purple9   => '5;133',
  purple10  => '5;129',
  purple11  => '5;128',
  purple12  => '5;127',
  purple13  => '5;126',
  purple14  => '5;125',
  purple15  => '5;111',
  purple16  => '5;110',
  purple17  => '5;109',
  purple18  => '5;105',
  purple19  => '5;104',
  purple20  => '5;103',
  purple21  => '5;099',
  purple22  => '5;098',
  purple23  => '5;097',
  purple24  => '5;096',
  purple25  => '5;093',
  purple26  => '5;092',
  purple27  => '5;091',
  purple28  => '5;090',

  purple29  => '5;055',
  purple30  => '5;054',

  cyan1     => '5;159',
  cyan2     => '5;158',
  cyan3     => '5;157',
  cyan4     => '5;153',
  cyan5     => '5;152',
  cyan6     => '5;151',
  cyan7     => '5;123',
  cyan8     => '5;122',
  cyan9     => '5;121',
  cyan10    => '5;117',
  cyan11    => '5;116',
  cyan12    => '5;115',
  cyan13    => '5;087',
  cyan14    => '5;086',
  cyan15    => '5;085',
  cyan16    => '5;081',
  cyan17    => '5;080',
  cyan18    => '5;079',
  cyan19    => '5;051',
  cyan20    => '5;050',
  cyan21    => '5;049',
  cyan22    => '5;045',
  cyan23    => '5;044',
  cyan24    => '5;043',

  orange1   => '5;208',
  orange2   => '5;172',
  orange3   => '5;202',
  orange4   => '5;166',
  orange5   => '5;130',
);

our $FG;
our $BG;

my $fg = "\e[38;";
my $bg = "\e[48;";

my($start, $end);

sub fg {
  # Call to fg() with zero args resets to defaults
  if(!@_) {
    # \e[38;0m
    return("\e[m");
  }
  $FG = 1;
  _color(@_);
}

sub bg {
  if(!@_) {
    # \e[48;0m
    # Will not work in xterm
    return("\e[m");
  }

  $BG = 1;
  _color(@_);
}

sub bold       { _color('bold',      @_); }
sub italic     { _color('italic',    @_); }
sub underline  { _color('underline', @_); }
sub inverse    { _color('inverse',   @_); }
sub get_colors { return \%color_names; }
sub clear      { return "\e[m"; }


# lookup(232) - gray24
# lookup('\e[38;5;191m') - yellow7

sub lookup {
  # Trying to lookup stuff like '\e[38;5;100mfoobar\e[0m' will NOT work
  # and will return undef
  my $color = shift;

  my @colors = ();
  if(ref($color) eq 'ARRAY') {
    push(@colors, @{$color});
  }
  else {
    push(@colors, $color);
  }

  for my $esc_str(@colors) {

    # Handle \e[38;5;100m type args
    $esc_str =~ s/^\e\[(?:3|4)8;//m;
    $esc_str =~ s/m$//m;

    # We are padding numbers < 100 with zeroes.
    # Handle this here.
    $esc_str =~ s/^5?;?0+(\d+)$/$1/m;

    # Make sure this is really a number before padding
    if(($esc_str =~ /^\d+$/m) and ($esc_str < 100)) {
      $esc_str = sprintf("%03d", $esc_str);
    }

    # Add the '5;' part again, so we can look it up in the table
    if($esc_str =~ /^\d+$/m) {
      $esc_str = "5;$esc_str";
    }
  }


  my %lookup = reverse(%color_names);

  if(scalar(@colors) == 1) {
    my $found_str = join('', @colors);
    return((exists($lookup{$found_str})) ? $lookup{$found_str} : undef);
  }
  else {
    my @result;
    for(@colors) {
      if(exists($lookup{$_})) {
        push(@result, $lookup{$_});
      }
    }
    return @result;
  }
}


sub _color {
  my($color_str, $data) = @_;

  my $access_by_numeric_index = 0;

  $color_str =~ s/grey/gray/m; # Alternative spelling

  # No key found in the table, and not using a valid number.
  # Return data if any, else the invalid color string.
  if( (! exists($color_names{$color_str})) and ($color_str !~ /^\d+$/m) ) {
    return ($data) ? $data : $color_str;
  }

  # Foreground or background?
  ($start) = ($FG)        ? "\e[38;" : "\e[48;";
  ($end)   = ($AUTORESET) ? "\e[m"  : '';

  # Allow access to not defined color values: fg(221);
  if( ($color_str =~ /^\d+$/m) and ($color_str < 256) and ($color_str > -1) ) {
    $color_str = $start . "5;$color_str" . 'm';
    $access_by_numeric_index = 1;
  }

  # Called with no data. The only useful operation here is to return the
  # attribute code with no end sequence. Basicly the same thing as if $AUTORESET
  # == 0.
  if(!defined($data)) { # 0 is a valid argument
    return ($access_by_numeric_index)
      ? $color_str
      : "$start$color_names{$color_str}m"
      ;
  }

  {
    # This is for operations like fg('bold', fg('red1'));
    no warnings; # For you, Test::More
    if($data =~ /;(\d+;\d+)m$/m) {
      my $esc = $1;
      my @escapes = values %color_names;
      for(@escapes) {
        if($esc eq $_) {
          return $start . $color_names{$color_str} . 'm' . $data;
        }
      }
    }

  } # end no warnings

  my @output;
  if(ref($data) eq 'ARRAY') {
    push(@output, @{$data});
  }
  else {
    push(@output, $data);
  }

  for my $line(@output) {
    if($access_by_numeric_index) {
      $line = $color_str . $line . $end;
    }
    else {
      $line = "$start$color_names{$color_str}m$line$end";
    }
  }

  # Restore state
  ($FG, $BG) = (0, 0);

  return (wantarray()) ? (@output) : (join('', @output));
}

sub uncolor {
  my @data = @_;
  return if !@data;

  if(ref($data[0]) eq 'ARRAY') {
    push(@data, @{$_[0]});
  }

  for(@data) {
    # Test::More enables warnings..
    if(defined($_)) {
      $_ =~ s/\e\[[0-9;]*m//gm;

      #s/\e\[(?:3|4)8;(?:;[0-9]+)?(;[0-9]+)m//g;
      #s/(?:\e|\033)\[[01234567]m//g;
    }
  }
  return (wantarray()) ? @data : join('', @data);
}


sub autoreset {
  $AUTORESET = shift;
  ($end) = ($AUTORESET) ? "\e[m" : '';

  return;
}



1;

__END__

=pod

=head1 NAME

Term::ExtendedColor - Color screen output using extended escape sequences

=head1 SYNOPSIS

    use Term::ExtendedColor qw(
      fg bg uncolor get_colors clear bold italic inverse underline lookup
    );

    # Or use the 'attributes' tag to only import the functions for setting
    # attributes.
    # This will import the following functions:

    # fg(), bg(), bold(), underline(), inverse(), italic(), clear()
    use Term::ExtendedColor ':attributes';

    ## Foreground colors

    print fg 'green15', "this is bright green foreground\n";
    my $red_text = fg('red2', "this is in red");

    ## Background colors

    print bg('red5', "Default foreground text on dark red background"), "\n";
    my $red_on_green = fg('red3', bg('green12', 'Red text on green background'));
    print "$red_on_green\n";

    ## Fall-through attributes

    Term::ExtendedColor::autoreset(0);
    my $bold  = fg('bold', 'This is bold');
    my $red   = fg('red2', 'This is red... and bold');
    my $green = bg('green28', 'This is bold red on green background');

    # Make sure to clear all attributes when autoreset turned OFF,
    # or else the users shell will be messed up

    my $clear = clear();
    print "$bold\n";
    print "$red\n";
    print "$green $clear\n";

    ## Non-color attributes

    # Turn on autoreset again
    Term::ExtendedColor::autoreset(1);

    for(qw(italic underline blink reverse bold)) {
      print fg($_, $_), "\n";
    }

    # For convenience

    my $bold   = bold("Bold text!");
    my $italic = italic("Text in italic!");

    ## Remove all attributes from input data
    my @colored;
    push(@colored, fg('bold', fg('red2', 'Bold and red')));
    push(@colored, fg('green13', fg('italic', 'Green, italic')));

    print "$_\n" for @colored;
    print "$_\n" for uncolor(@colored);

    ## Look up all mapped colors and print them in color

    for(0..255) {
      my $color_str = lookup($_);
      if(defined($color_str)) {
        printf("%25s => %s\n", fg($color_str, $color_str), $_);
      }
    }


=head1 DESCRIPTION

B<Term::ExtendedColor> provides functions for sending so called extended escape
sequences, most notably colors. It can be used to set the current text
attributes or to apply a set of attributes to a string and reset the current
text attributes at the end of the string.

This module does (almost) the same thing as the core L<Term::ANSIColor> module,
plus a little more. First off, as the name suggests, it handles the extended
colorset - that means, the ANSI colors plus 240 extra colors, building up a
matrix of a total of 256 colors.

=head1 EXPORTS

None by default.

=head1 FUNCTIONS

=head2 fg()

Parameters: $color_by_name || $color_by_index | \@strings, \@integers

Returns:    $string | \@strings

  my $green = fg('green2', 'green foreground');
  my @blue  = fg('blue4',  ['takes arrayrefs as well']);

  my $arbitary_color = fg(4, 'This is colored in the fifth ANSI color');

Set foreground colors and attributes.

Called without arguments is the same as calling C<clear()>.

expects a string with an attribute attached to it as its first argument,
and optionally any number of additional strings which the operation will be
performed upon.
If the internal C<$AUTORESET> variabe is non-zero (default), the list of strings
will be mapped with the attribute in front and the 'reset' attribute in the
end. This is for convience, but the behaviour can be changed by calling
B<Term::ExtendedColor::autoreset(0)>.

Be warned, you'll need to reset manually, or else the set attributes will last
after your program is finished, leaving the user with a not-so-funny prompt.

If you pass an invalid attribute, the original data will be returned
unmodified.

=head2 bg()

Parameters: $color_by_name || $color_by_index | \@strings, \@integers

Returns:    $string | \@strings

  my $green_bg = bg('green4', 'green background');
  my @blue_bg  = bg('blue6',  ['blue background']);

Like C<fg()>, but sets background colors.

=head2 uncolor()

Parameters: $string | \@strings

Returns:    $string | \@strings

  my $stripped = uncolor($colored_data);
  my @no_color = uncolor(\@colored);

strips the input data from escape sequences.

=head2 lookup()

Parameters: $string | \@strings

Returns:    $string | \@strings

  my $str = lookup(255); # gray1

  my $fg  = fg('red4');
  $str    = lookup($str);

  my $data   = [197, 220, 148..196];
  my @result = lookup($data);

look up argument in a reverse table. Argument can be either a full escape
sequence or a number. Alternatively, you may pass a reference to an array as
the first argument.

Returns undef if no such attribute exists.

=head2 get_colors()

Parameters: None

Returns:    \%attributes

  my $colors = get_colors();

returns a hash reference with all available attributes and colors.

=head2 clear()

Parameters: None

Returns:    $string

returns the code for clearing current attributes and resets to normal

=head2 autoreset

Parameters: Boolean

turn autoreset on/off. Default is on. autoreset is not exported by default,
you have to call it using the fully qualified name
C<Term::ExtendedColor::autoreset()>.

=head1 WRAPPERS

A couple of simple wrappers are provided for convenience.

=head2 bold()

Parameters: @data | \@data

Convenience function that might be used in place of C<fg('bold', @data)>;

=head2 italic()

Parameters: @data | \@data

Convenience function that might be used in place of C<fg('italic', @data)>;

=head2 underline()

Parameters: @data | \@data

Convenience function that might be used in place of C<fg('underline', @data)>;

=head2 inverse()

Parameters: @data | \@data

Reverse video / inverse.
Convenience function that might be used in place of C<fg('inverse', @data)>;

=head1 NOTES

The codes generated by this module complies to the extension of the ANSI colors
standard first implemented in xterm in 1999. The first 16 color indexes (0 - 15)
is the regular ANSI colors, while index 16 - 255 is the extension.
Not all terminal emulators support this extension, though I've had a hard time
finding one that doesn't. :)

  Terminal    256 colors
  ----------------------
  aterm               no
  eterm              yes
  gnome-terminal     yes
  konsole            yes
  lxterminal         yes
  mrxvt              yes
  roxterm            yes
  rxvt                no
  rxvt-unicode       yes *
  sakura             yes
  terminal           yes
  terminator         yes
  vte                yes
  xterm              yes
  iTerm2             yes
  Terminal.app        no

  GNU Screen         yes
  tmux               yes
  TTY/VC              no

* Previously needed a patch. Full support was added in version 9.09.

There's no way to give these extended color meaninful names.

Our first thought was to map them against some standard color names, like those
in the HTML 4.0 specification or the SVG one. They didn’t match.

Then I thought of the X11 color names – they surely must match!
Nope.

Therefore, they are named by their base color (red, green, magenta) plus index;
The first index (always 1) is the brightest shade of that particular color,
while the last index is the darkest.

A full list of available color can be retrieved with C<get_colors()>, but here's
a list for reference:

=head2 Attributes

  reset, clear, normal        reset all attributes
  bold, bright                bold or bright, depending on implementation
  faint                       decreased intensity (not widely supported)
  italic, cursive             italic or cursive
  underline, underscore       underline
  blink                       slow blink
  blink_ms                    rapid blink (only supported in MS DOS)
  reverse, inverse, negative  reverse video
  conceal                     conceal, or hide (not widely supported)

=head2 Colors

  FIRST       LAST

  red1        red5
  blue1       blue17
  cyan1       cyan24
  gray1       gray24
  green1      green28
  orange1     orange5
  purple1     purple30
  yellow1     yellow18
  magenta1    magenta26

=head1 SEE ALSO

L<Term::ExtendedColor::Xresources>, L<Term::ANSIColor>

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 CONTRIBUTORS

None required yet.

=head1 COPYRIGHT

Copyright 2010, 2011 the Term::ExtendedColors L</AUTHOR> and L</CONTRIBUTORS> as
listed above.

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut
