package Term::ExtendedColor;
use strict;
use warnings;

BEGIN {
  use Exporter;
  use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

  $VERSION = '0.234';
  @ISA     = qw(Exporter);

  @EXPORT_OK = qw(
    uncolor
    uncolour
    get_colors
    get_colours
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
    all        => [ @EXPORT_OK ],
  );
}

{
  no warnings;
  *uncolour    = *Term::ExtendedColor::uncolor;
  *get_colours = *Term::ExtendedColor::get_colors;
}

our $AUTORESET = 1;

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

  red1      => '5;196',
  red2      => '5;160',
  red3      => '5;124',
  red4      => '5;088',
  red5      => '5;052',

  green1    => '5;156',
  green2    => '5;150',
  green3    => '5;120',
  green4    => '5;114',
  green5    => '5;084',
  green6    => '5;078',
  green7    => '5;155',
  green8    => '5;149',
  green9    => '5;119',
  green10   => '5;113',
  green11   => '5;083',
  green12   => '5;077',
  green13   => '5;047',
  green14   => '5;041',
  green15   => '5;118',
  green16   => '5;112',
  green17   => '5;082',
  green18   => '5;076',
  green19   => '5;046',
  green20   => '5;040',
  green21   => '5;034',
  green22   => '5;028',
  green23   => '5;022',
  green24   => '5;107',
  green25   => '5;071',
  green26   => '5;070',
  green27   => '5;064',
  green28   => '5;065',

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

  # Approximations of X11 color mappings
  # https://secure.wikimedia.org/wikipedia/en/wiki/X11%20colors

  aquamarine1       => '5;086',
  aquamarine3       => '5;079',
  blueviolet        => '5;057',
  cadetblue1        => '5;072',
  cadetblue2        => '5;073',
  chartreuse1       => '5;118',
  chartreuse2       => '5;082',
  chartreuse3       => '5;070',
  chartreuse4       => '5;064',
  cornflowerblue    => '5;069',
  cornsilk1         => '5;230',
  darkblue          => '5;018',
  darkcyan          => '5;036',
  darkgoldenrod     => '5;136',
  darkgreen         => '5;022',
  darkkhaki         => '5;143',
  darkmagenta1      => '5;090',
  darkmagenta2      => '5;091',
  darkolivegreen1   => '5;191',
  darkolivegreen2   => '5;155',
  darkolivegreen3   => '5;107',
  darkolivegreen4   => '5;113',
  darkolivegreen5   => '5;149',
  darkorange3       => '5;130',
  darkorange4       => '5;166',
  darkorange1       => '5;208',
  darkred1          => '5;052',
  darkred2          => '5;088',
  darkseagreen1     => '5;158',
  darkseagreen2     => '5;157',
  darkseagreen3     => '5;150',
  darkseagreen4     => '5;071',
  darkslategray1    => '5;123',
  darkslategray2    => '5;087',
  darkslategray3    => '5;116',
  darkturquoise     => '5;044',
  darkviolet        => '5;128',
  deeppink1         => '5;198',
  deeppink2         => '5;197',
  deeppink3         => '5;162',
  deeppink4         => '5;125',
  deepskyblue1      => '5;039',
  deepskyblue2      => '5;038',
  deepskyblue3      => '5;031',
  deepskyblue4      => '5;023',
  deepskyblue4      => '5;025',
  dodgerblue1       => '5;033',
  dodgerblue2       => '5;027',
  dodgerblue3       => '5;026',
  gold1             => '5;220',
  gold3             => '5;142',
  greenyellow       => '5;154',
  grey0             => '5;016',
  grey100           => '5;231',
  grey11            => '5;234',
  grey15            => '5;235',
  grey19            => '5;236',
  grey23            => '5;237',
  grey27            => '5;238',
  grey30            => '5;239',
  grey3             => '5;232',
  grey35            => '5;240',
  grey37            => '5;059',
  grey39            => '5;241',
  grey42            => '5;242',
  grey46            => '5;243',
  grey50            => '5;244',
  grey53            => '5;102',
  grey54            => '5;245',
  grey58            => '5;246',
  grey62            => '5;247',
  grey63            => '5;139',
  grey66            => '5;248',
  grey69            => '5;145',
  grey70            => '5;249',
  grey74            => '5;250',
  grey7             => '5;233',
  grey78            => '5;251',
  grey82            => '5;252',
  grey84            => '5;188',
  grey85            => '5;253',
  grey89            => '5;254',
  grey93            => '5;255',
  honeydew2         => '5;194',
  hotpink2          => '5;169',
  hotpink3          => '5;132',
  hotpink           => '5;205',
  indianred1        => '5;203',
  indianred         => '5;167',
  khaki1            => '5;228',
  khaki3            => '5;185',
  lightcoral        => '5;210',
  lightcyan1        => '5;195',
  lightcyan3        => '5;152',
  lightgoldenrod1   => '5;227',
  lightgoldenrod2   => '5;186',
  lightgoldenrod3   => '5;179',
  lightgreen        => '5;119',
  lightpink1        => '5;217',
  lightpink3        => '5;174',
  lightpink4        => '5;095',
  lightsalmon1      => '5;216',
  lightsalmon3      => '5;137',
  lightsalmon3      => '5;173',
  lightseagreen     => '5;037',
  lightskyblue1     => '5;153',
  lightskyblue3     => '5;109',
  lightskyblue3     => '5;110',
  lightslateblue    => '5;105',
  lightslategrey    => '5;103',
  lightsteelblue1   => '5;189',
  lightsteelblue3   => '5;146',
  lightsteelblue    => '5;147',
  lightyellow3      => '5;187',
  mediumorchid1     => '5;171',
  mediumorchid3     => '5;133',
  mediumorchid      => '5;134',
  mediumpurple1     => '5;141',
  mediumpurple2     => '5;135',
  mediumpurple3     => '5;097',
  mediumpurple4     => '5;060',
  mediumpurple      => '5;104',
  mediumspringgreen => '5;049',
  mediumturquoise   => '5;080',
  mediumvioletred   => '5;126',
  mistyrose1        => '5;224',
  mistyrose3        => '5;181',
  navajowhite1      => '5;223',
  navajowhite3      => '5;144',
  navyblue          => '5;017',
  orangered1        => '5;202',
  orchid1           => '5;213',
  orchid2           => '5;212',
  orchid            => '5;170',
  palegreen1        => '5;121',
  palegreen3        => '5;077',
  paleturquoise1    => '5;159',
  paleturquoise4    => '5;066',
  palevioletred1    => '5;211',
  pink1             => '5;218',
  pink3             => '5;175',
  plum1             => '5;219',
  plum2             => '5;183',
  plum3             => '5;176',
  plum4             => '5;096',
  purple            => '5;129',
  rosybrown         => '5;138',
  royalblue1        => '5;063',
  salmon1           => '5;209',
  sandybrown        => '5;215',
  seagreen1         => '5;084',
  seagreen2         => '5;083',
  seagreen3         => '5;078',
  skyblue1          => '5;117',
  skyblue2          => '5;111',
  skyblue3          => '5;074',
  slateblue1        => '5;099',
  slateblue3        => '5;061',
  springgreen1      => '5;048',
  springgreen2      => '5;042',
  springgreen3      => '5;035',
  springgreen4      => '5;029',
  steelblue1        => '5;075',
  steelblue3        => '5;068',
  steelblue         => '5;067',
  tan               => '5;180',
  thistle1          => '5;225',
  thistle3          => '5;182',
  turquoise2        => '5;045',
  turquoise4        => '5;030',
  violet            => '5;177',
  wheat1            => '5;229',
  wheat4            => '5;101',

);

our($fg_called, $bg_called);

my ($fg, $bg) = ("\e[38;", "\e[48;");
my($start, $end);

sub fg {
  # Call to fg() with zero args resets to defaults
  if(!@_) {
    return("\e[m");
  }
  $fg_called = 1;
  _color(@_);
}

sub bg {
  if(!@_) {
    # \e[48;0m
    # Will not work in xterm
    return("\e[m");
  }

  $bg_called = 1;
  _color(@_);
}


sub bold       { $fg_called = 1; _color('bold',      @_); }
sub italic     { $fg_called = 1; _color('italic',    @_); }
sub underline  { $fg_called = 1; _color('underline', @_); }
sub inverse    { $fg_called = 1; _color('inverse',   @_); }
sub get_colors { return \%color_names; }
sub clear      { defined(wantarray()) ? return "\e[m" : print "\e[m"; }


sub _color {
  my($color_str, $data) = @_;

  my $access_by_numeric_index = 0;

  # No key found in the table, and not using a valid number.
  # Return data if any, else the invalid color string.
  if( (! exists($color_names{$color_str})) and ($color_str !~ /^\d+$/m) ) {
    return ($data) ? $data : $color_str;
  }

  # Foreground or background?
  ($start) = ($fg_called) ? "\e[38;" : "\e[48;";
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
  ($fg_called, $bg_called) = (0, 0);

  return (wantarray()) ? (@output) : (join('', @output));
}

sub uncolor {
  my @data = @_;
  return if !@data;

  if(ref($data[0]) eq 'ARRAY') {
    my $ref = shift @data;
    push(@data, @{$ref});
  }

  for(@data) {
    # Test::More enables warnings..
    if(defined($_)) {
      $_ =~ s/\e\[[0-9;]*m//gm;
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

Term::ExtendedColor - Color screen output using 256 colors

=head1 SYNOPSIS

    use Term::ExtendedColor qw(:all);

    # Or use the 'attributes' tag to only import the functions for setting
    # attributes.
    # This will import the following functions:

    # fg(), bg(), bold(), underline(), inverse(), italic(), clear()
    use Term::ExtendedColor ':attributes';

    ## Foreground colors

    my $red_text = fg('red2', 'this is in red');
    my $spring   = fg('springgreen3', 'this is green');

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

    my $bolded = bold("Bold text!");
    my $italic = italic("Text in italics!");

    ## Remove all attributes from input data
    my @colored;
    push(@colored, fg('bold', fg('red2', 'Bold and red')));
    push(@colored, fg('green13', fg('italic', 'Green, italic')));

    print "$_\n" for @colored;
    print "$_\n" for uncolor(@colored);

=head1 DESCRIPTION

B<Term::ExtendedColor> provides functions for sending so called extended escape
sequences to the terminal. This ought to be used with a 256-color compatible
terminal; see the NOTES section for a matrix of terminal emulators currently
supporting this.

=head1 EXPORTS

None by default.

Two tags are provided for convience:

  # Import all functions
  use Term::ExtendedColor qw(:all);

  # Import functions for setting attributes
  # fg(), bg(), bold(), italic(), underline(), inverse(), clear()
  use Term::ExtendedColor qw(:attributes);

=head1 FUNCTIONS

=head2 fg($color, $string)

  my $green = fg('green2', 'green foreground');
  my @blue  = fg('blue4',  ['takes arrayrefs as well']);

  my $x_color = fg('mediumorchid1', 'Using mappings from the X11 rgb.txt');

  my $arbitary_color = fg(4, 'This is colored in the fifth ANSI color');

Set foreground colors and attributes.

See L<COLORS AND ATTRIBUTES> for valid first arguments. Additionally, colors can
be specified using their index value:

  my $yellow = fg(220, 'Yellow');

If the internal C<$AUTORESET> variable is non-zero (default), every element in
the list of strings will be wrapped in escape sequences in such a way that the
requested attributes will be set before the string and reset to defaults after
the string.

Fall-through attributes can be enabled by setting C<$AUTORESET> to a false
value.

  Term::ExtendedColor::autoreset( 0 );
  my $red   = fg('red1', 'Red');
  my $green = fg('green1', 'Green');

  print "Text after $red is red until $green\n";
  print "Text is still green, ", bold('and now bold as well!');

  # If you exit now without resetting the colors and attributes, chances are
  # your prompt will be messed up.

  clear(); # All back to normal

If an invalid attribute is passed, the original data will be returned
unmodified.

=head2 bg($color, $string)

  my $green_bg = bg('green4', 'green background');
  my @blue_bg  = bg('blue6',  ['blue background']);

Like C<fg()>, but sets background colors.

=head2 uncolor($string) | uncolour($string)

  my $stripped = uncolor($colored_data);
  my @no_color = uncolor(\@colored);
  my @no_color = uncolor(@colored);

Remove all attribute and color escape sequences from the input.

See L<uncolor> for a command-line utility using this function.

=head2 get_colors() | get_colours()

  my $colors = get_colors();

Returns a hash reference with all available attributes and colors.

=head2 clear()

When called in scalar context, returns the escape sequence that resets all
attributes to their defaults.

When called in void context, prints it directly.

=head2 autoreset()

Turn autoreset on/off. Enabled by default.

  Term::ExtendedColor::autoreset( 0 ); # Turn off autoreset

=head2 bold(@data)

Convenience function that might be used in place of C<fg('bold', @data)>;

=head2 italic(@data)

Convenience function that might be used in place of C<fg('italic', @data)>;

=head2 underline(@data)

Convenience function that might be used in place of C<fg('underline', @data)>;

=head2 inverse(@data)

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

There's no way to give these extended colors meaningful names.

Our first thought was to map them against some standard color names, like those
in the HTML 4.0 specification or the SVG one. They didn't match.

Therefore, they are named by their base color (red, green, magenta) plus index;
The first index (always 1) is the brightest shade of that particular color,
while the last index is the darkest.

It's also possible to use some X color names, as defined in C<rgb.txt>. Do note
that the color values do not match exactly; it's just an approximation.

A full list of available colors can be retrieved with C<get_colors()>.
See L<COLORS AND ATTRIBUTES> for full list. All mapped colors can also be
retrieved programmatically with C<get_colors()>.

=head1 COLORS AND ATTRIBUTES

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

=head2 Standard color map

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

=head2 X color names

  aquamarine1
  aquamarine3
  blueviolet
  cadetblue1
  cadetblue2
  chartreuse1
  chartreuse2
  chartreuse3
  chartreuse4
  cornflowerblue
  cornsilk1
  darkblue
  darkcyan
  darkgoldenrod
  darkgreen
  darkkhaki
  darkmagenta1
  darkmagenta2
  darkolivegreen1
  darkolivegreen2
  darkolivegreen3
  darkolivegreen4
  darkolivegreen5
  darkorange3
  darkorange4
  darkorange1
  darkred1
  darkred2
  darkseagreen1
  darkseagreen2
  darkseagreen3
  darkseagreen4
  darkslategray1
  darkslategray2
  darkslategray3
  darkturquoise
  darkviolet
  deeppink1
  deeppink2
  deeppink3
  deeppink4
  deepskyblue1
  deepskyblue2
  deepskyblue3
  deepskyblue4
  deepskyblue4
  dodgerblue1
  dodgerblue2
  dodgerblue3
  gold1
  gold3
  greenyellow
  grey0
  grey100
  grey11
  grey15
  grey19
  grey23
  grey27
  grey30
  grey3
  grey35
  grey37
  grey39
  grey42
  grey46
  grey50
  grey53
  grey54
  grey58
  grey62
  grey63
  grey66
  grey69
  grey70
  grey74
  grey7
  grey78
  grey82
  grey84
  grey85
  grey89
  grey93
  honeydew2
  hotpink2
  hotpink3
  hotpink
  indianred1
  indianred
  khaki1
  khaki3
  lightcoral
  lightcyan1
  lightcyan3
  lightgoldenrod1
  lightgoldenrod2
  lightgoldenrod3
  lightgreen
  lightpink1
  lightpink3
  lightpink4
  lightsalmon1
  lightsalmon3
  lightsalmon3
  lightseagreen
  lightskyblue1
  lightskyblue3
  lightskyblue3
  lightslateblue
  lightslategrey
  lightsteelblue1
  lightsteelblue3
  lightsteelblue
  lightyellow3
  mediumorchid1
  mediumorchid3
  mediumorchid
  mediumpurple1
  mediumpurple2
  mediumpurple3
  mediumpurple4
  mediumpurple
  mediumspringgreen
  mediumturquoise
  mediumvioletred
  mistyrose1
  mistyrose3
  navajowhite1
  navajowhite3
  navyblue
  orangered1
  orchid1
  orchid2
  orchid
  palegreen1
  palegreen3
  paleturquoise1
  paleturquoise4
  palevioletred1
  pink1
  pink3
  plum1
  plum2
  plum3
  plum4
  purple
  rosybrown
  royalblue1
  salmon1
  sandybrown
  seagreen1
  seagreen2
  seagreen3
  skyblue1
  skyblue2
  skyblue3
  slateblue1
  slateblue3
  springgreen1
  springgreen2
  springgreen3
  springgreen4
  steelblue1
  steelblue3
  steelblue
  tan
  thistle1
  thistle3
  turquoise2
  turquoise4
  violet
  wheat1
  wheat4

=head1 SEE ALSO

L<Term::ExtendedColor::Xresources>, L<Term::ExtendedColor::TTY>, L<Term::ANSIColor>

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  m@japh.se
  http://japh.se

=head1 CONTRIBUTORS

None required yet.

=head1 COPYRIGHT

Copyright 2010, 2011, 2018 the B<Term::ExtendedColor> L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut
