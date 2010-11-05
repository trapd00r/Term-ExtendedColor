package Term::ExtendedColor;
require Exporter;
@ISA = 'Exporter';
our @EXPORT = qw(color_default color_by_name color $AUTORESET c);
use Data::Dumper;
use Carp;

our $AUTORESET;

my $esc = "\e[38;5;";
my $end = ($AUTORESET) ? "\e[0m" : '';

my %color_map = (
  ansi  =>
  [
    0 .. 15,
  ],
  red   =>
  [
    124,
    160,
    196,
  ],
  green => 
  [
    22,
    40,
    46,
    64,
    82,
    106,
    112,
    118,
    154,
  ],
  grey  =>
  [
    232 .. 255,
  ],
);

my %color_names = (
  # light .. dark
  red1    => 196,
  red2    => 160,
  red3    => 124,
  red4    => 88,
  red5    => 52,

  green1  => 156,
  green2  => 155,
  green3  => 154,
  green4  => 148,
  green5  => 118,
  green6  => 112,
  green7  => 82,
  green8  => 76,
  green9  => 40,
  green10 => 46,
  green11 => 106,
  green12 => 100,

  yellow1 => 184,
  yellow2 => 220,
  yellow3 => 190,
  yellow4 => 226,
  yellow5 => 227,

  orange1 => 214,
  orange2 => 178,
  orange3 => 172,
  orange4 => 208,
  orange5 => 202,
  orange6 => 166,
  orange7 => 130,
);

sub c {
  my $color_str = shift;
  my @data = @_;
  return undef if(!defined($color_str));

  if(!defined($color_names{$color_str})) {
    return(@data);
    #croak("$color_str is not a valid name\n");
  }

  @data = map{ "$esc$color_names{$color_str}m$_$end" } @data;
  return @data;
}




sub color {
  my $color_index = shift;
  my @data = @_;
  return (undef) if(scalar(@data) == 0);

  if(($color_index =~ m/^\d+$/) and ($color_index <= 255) and ($color_index >=0)) {
    if($AUTORESET) {
      @data = map{ "\e[38;5;$color_index" . 'm' . $_ . "\e[0m"; } @data;
    }
    else {
      @data = map{ "\e[38;5;$color_index" . 'm' . $_; } @data;
    }
  }
  elsif(exists($color_map{$color_index})) {
    @data = map{ "\e[38;5;$color_map{$color_index}->[3]m$_\e[0m"} @data;
    #print Dumper \%color_map;
  }
  return @data;
}


sub color_by_name {
  my $color_name  = shift;
  my $color_index = shift;
  my @data = @_;

  my $esc = ($color_name eq 'ansi') ? "\e[3" : "\e[38;5;";
  my $end = ($AUTORESET) ? "\e[0m" : '';

  if(!exists($color_map{$color_name})) {
    return -1;
  }

  if($color_index == -1) {
    if($color_name eq 'ansi') {
      $esc = "\e[3";
    }
    $color_index = 0;
    for(@data) {
      if($color_index == scalar(@{$color_map{$color_name}})) {
        $color_index = 0;
      }
      $_ = "$esc$color_map{$color_name}->[$color_index]m$_$end";
      #print Dumper $_;
      $color_index++;
    }
    return(@data);
  }
  elsif( ($color_index !~ /^\d+$/)
      or ($color_index > scalar(@{$color_map{$color_name}})) ) {
    print "UH\n";
    return 1;
  }
  @data = map{ "\e[38;5;$color_map{$color_name}->[$color_index]m$_$end" } @data;
  return(@data);
}

sub color_default {
  return("\e[0m");
}

1;
