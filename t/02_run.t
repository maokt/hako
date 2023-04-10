use strict;
use Test::More 0.98;
use File::Temp;

my $HAKO = $ENV{HAKO} || "./blib/script/hako.pl";

my $box = File::Temp->newdir;

my $ls;

$ls = qx{$HAKO $box ls};
is $?, 0, "no error";
is $ls, "", "empty dir";

$ls = qx{$HAKO $box ls $ENV{HOME}};
is $?, 0, "no error";
is $ls, "", "empty home";

system "$HAKO $box touch Cat";
is $?, 0, "touched Cat";

ok -f "$box/Cat", "The Cat is in the box";
ok ! -f "$ENV{HOME}/Cat", "The Cat is not at home";

$ls = qx{$HAKO $box ls $ENV{HOME}};
is $?, 0, "no error";
chomp $ls;
is $ls, "Cat", "The Cat in the box is at home";

done_testing;

