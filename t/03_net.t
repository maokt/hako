use strict;
use Test::More 0.98;
use File::Temp;

my $HAKO = $ENV{HAKO} || "./blib/script/hako.pl";

my $box = File::Temp->newdir;
my $cmd = "grep : /proc/net/dev";
my @links;

# sanity check: make sure we have more than one network link
@links = qx{$cmd};
is $?, 0, "ip link works with no error";
ok @links > 1, "more than one net link outside";

my $n = @links;

@links = qx{$HAKO $box $cmd};
is $?, 0, "no error";
is @links, $n, "same number of net links inside the regular box";

@links = qx{$HAKO -n $box $cmd};
is $?, 0, "no error";
is @links, 1, "just one net link inside the isolated box";

done_testing;

