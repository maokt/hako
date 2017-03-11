use strict;
use Test::More 0.98;
use File::Temp;
use File::Basename;

# We want to run the script, which we are probably still building.
$ENV{PATH} = "blib/script:$ENV{PATH}";

# make sure we can work with a relative path (early versions failed silently)

my $temp = File::Temp->newdir;
my ($box, $dir) = fileparse("$temp");

$ENV{HOME} = $dir;
chdir $dir or die "cannot chdir $dir: $!\n";

system "hako $box touch Cat";

ok -f "$box/Cat", "The Cat is in the box";
ok ! -f "$ENV{HOME}/Cat", "The Cat is not at home";

done_testing;

