use strict;
use Test::More 0.98;
use File::Temp;
use File::Basename;

my $HAKO = $ENV{HAKO} || "./blib/script/hako.pl";

# make sure we can work with a relative path (early versions failed silently)

my $temp = File::Temp->newdir(DIR => ".");
my ($box, $dir) = fileparse("$temp");

system "$HAKO $box touch Cat";
is $?, 0, "touched Cat";

ok -f "$box/Cat", "The Cat is in the box";
ok ! -f "$ENV{HOME}/Cat", "The Cat is not at home";

done_testing;

