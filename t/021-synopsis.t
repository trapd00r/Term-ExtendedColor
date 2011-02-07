use strict;
use Test::More;

eval "use Test::Synopsis";

plan skip_all => 'Test::Synopsis required for testing synopsis' if $@;

all_synopsis_ok()
