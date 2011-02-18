package Term::ExtendedColor;
use strict;

BEGIN {
  use Exporter;
  use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

  $VERSION = '0.192';
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
    all        => [ @EXPORT_OK ],
  );
}

our $AUTORESET = 1;


# There a no way to give these meaningful names.
# The X11 rgb names doesn't match, neither does
# any SVG or HTML colorset.
# They are mapped from light to dark.
#
#
#Generated from c:/pdsrc/xterm-222/256colres.h by allcolors.pl
# Those are approximately representations of the colors found in rgb.txt
#016 => Grey0
#017 => NavyBlue
#018 => DarkBlue
#019 => Blue3
#020 => Blue3
#021 => Blue1
#022 => DarkGreen
#023 => DeepSkyBlue4
#024 => DeepSkyBlue4
#025 => DeepSkyBlue4
#026 => DodgerBlue3
#027 => DodgerBlue2
#028 => Green4
#029 => SpringGreen4
#030 => Turquoise4
#031 => DeepSkyBlue3
#032 => DeepSkyBlue3
#033 => DodgerBlue1
#034 => Green3
#035 => SpringGreen3
#036 => DarkCyan
#037 => LightSeaGreen
#038 => DeepSkyBlue2
#039 => DeepSkyBlue1
#040 => Green3
#041 => SpringGreen3
#042 => SpringGreen2
#043 => Cyan3
#044 => DarkTurquoise
#045 => Turquoise2
#046 => Green1
#047 => SpringGreen2
#048 => SpringGreen1
#049 => MediumSpringGreen
#050 => Cyan2
#051 => Cyan1
#052 => DarkRed
#053 => DeepPink4
#054 => Purple4
#055 => Purple4
#056 => Purple3
#057 => BlueViolet
#058 => Orange4
#059 => Grey37
#060 => MediumPurple4
#061 => SlateBlue3
#062 => SlateBlue3
#063 => RoyalBlue1
#064 => Chartreuse4
#065 => DarkSeaGreen4
#066 => PaleTurquoise4
#067 => SteelBlue
#068 => SteelBlue3
#069 => CornflowerBlue
#070 => Chartreuse3
#071 => DarkSeaGreen4
#072 => CadetBlue
#073 => CadetBlue
#074 => SkyBlue3
#075 => SteelBlue1
#076 => Chartreuse3
#077 => PaleGreen3
#078 => SeaGreen3
#079 => Aquamarine3
#080 => MediumTurquoise
#081 => SteelBlue1
#082 => Chartreuse2
#083 => SeaGreen2
#084 => SeaGreen1
#085 => SeaGreen1
#086 => Aquamarine1
#087 => DarkSlateGray2
#088 => DarkRed
#089 => DeepPink4
#090 => DarkMagenta
#091 => DarkMagenta
#092 => DarkViolet
#093 => Purple
#094 => Orange4
#095 => LightPink4
#096 => Plum4
#097 => MediumPurple3
#098 => MediumPurple3
#099 => SlateBlue1
#100 => Yellow4
#101 => Wheat4
#102 => Grey53
#103 => LightSlateGrey
#104 => MediumPurple
#105 => LightSlateBlue
#106 => Yellow4
#107 => DarkOliveGreen3
#108 => DarkSeaGreen
#109 => LightSkyBlue3
#110 => LightSkyBlue3
#111 => SkyBlue2
#112 => Chartreuse2
#113 => DarkOliveGreen3
#114 => PaleGreen3
#115 => DarkSeaGreen3
#116 => DarkSlateGray3
#117 => SkyBlue1
#118 => Chartreuse1
#119 => LightGreen
#120 => LightGreen
#121 => PaleGreen1
#122 => Aquamarine1
#123 => DarkSlateGray1
#124 => Red3
#125 => DeepPink4
#126 => MediumVioletRed
#127 => Magenta3
#128 => DarkViolet
#129 => Purple
#130 => DarkOrange3
#131 => IndianRed
#132 => HotPink3
#133 => MediumOrchid3
#134 => MediumOrchid
#135 => MediumPurple2
#136 => DarkGoldenrod
#137 => LightSalmon3
#138 => RosyBrown
#139 => Grey63
#140 => MediumPurple2
#141 => MediumPurple1
#142 => Gold3
#143 => DarkKhaki
#144 => NavajoWhite3
#145 => Grey69
#146 => LightSteelBlue3
#147 => LightSteelBlue
#148 => Yellow3
#149 => DarkOliveGreen3
#150 => DarkSeaGreen3
#151 => DarkSeaGreen2
#152 => LightCyan3
#153 => LightSkyBlue1
#154 => GreenYellow
#155 => DarkOliveGreen2
#156 => PaleGreen1
#157 => DarkSeaGreen2
#158 => DarkSeaGreen1
#159 => PaleTurquoise1
#160 => Red3
#161 => DeepPink3
#162 => DeepPink3
#163 => Magenta3
#164 => Magenta3
#165 => Magenta2
#166 => DarkOrange3
#167 => IndianRed
#168 => HotPink3
#169 => HotPink2
#170 => Orchid
#171 => MediumOrchid1
#172 => Orange3
#173 => LightSalmon3
#174 => LightPink3
#175 => Pink3
#176 => Plum3
#177 => Violet
#178 => Gold3
#179 => LightGoldenrod3
#180 => Tan
#181 => MistyRose3
#182 => Thistle3
#183 => Plum2
#184 => Yellow3
#185 => Khaki3
#186 => LightGoldenrod2
#187 => LightYellow3
#188 => Grey84
#189 => LightSteelBlue1
#190 => Yellow2
#191 => DarkOliveGreen1
#192 => DarkOliveGreen1
#193 => DarkSeaGreen1
#194 => Honeydew2
#195 => LightCyan1
#196 => Red1
#197 => DeepPink2
#198 => DeepPink1
#199 => DeepPink1
#200 => Magenta2
#201 => Magenta1
#202 => OrangeRed1
#203 => IndianRed1
#204 => IndianRed1
#205 => HotPink
#206 => HotPink
#207 => MediumOrchid1
#208 => DarkOrange
#209 => Salmon1
#210 => LightCoral
#211 => PaleVioletRed1
#212 => Orchid2
#213 => Orchid1
#214 => Orange1
#215 => SandyBrown
#216 => LightSalmon1
#217 => LightPink1
#218 => Pink1
#219 => Plum1
#220 => Gold1
#221 => LightGoldenrod2
#222 => LightGoldenrod2
#223 => NavajoWhite1
#224 => MistyRose1
#225 => Thistle1
#226 => Yellow1
#227 => LightGoldenrod1
#228 => Khaki1
#229 => Wheat1
#230 => Cornsilk1
#231 => Grey100
#232 => Grey3
#233 => Grey7
#234 => Grey11
#235 => Grey15
#236 => Grey19
#237 => Grey23
#238 => Grey27
#239 => Grey30
#240 => Grey35
#241 => Grey39
#242 => Grey42
#243 => Grey46
#244 => Grey50
#245 => Grey54
#246 => Grey58
#247 => Grey62
#248 => Grey66
#249 => Grey70
#250 => Grey74
#251 => Grey78
#252 => Grey82
#253 => Grey85
#254 => Grey89
#255 => Grey93


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
);


our $FG;
our $BG;

my $fg = "\e[38;";
my $bg = "\e[48;";

my($start, $end);

sub fg {
  # Call to fg() with zero args resets to defaults
  if(!@_) {
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


sub bold       { $FG = 1; _color('bold',      @_); }
sub italic     { $FG = 1; _color('italic',    @_); }
sub underline  { $FG = 1; _color('underline', @_); }
sub inverse    { $FG = 1; _color('inverse',   @_); }
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

    use Term::ExtendedColor qw(:all);

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

    my $bolded = bold("Bold text!");
    my $italic = italic("Text in italics!");

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

A full list of available color can be retrieved with C<get_colors()>.
Here's a full list for referencce;

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

L<Term::ExtendedColor::Xresources>, L<Term::ExtendedColor::TTY>, L<Term::ANSIColor>

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 CONTRIBUTORS

None required yet.

=head1 COPYRIGHT

Copyright 2010, 2011 the B<Term::ExtendedColors> L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut
