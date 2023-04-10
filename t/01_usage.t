use strict;
use Test::More 0.98;

my $HAKO = $ENV{HAKO} || "./blib/script/hako.pl";

my $out;

$out = qx{$HAKO 2>&1};
is $?>>8, 64, "$HAKO usage";
like $out, qr/^usage: /;

$out = qx{$HAKO --help 2>&1};
is $?>>8, 0, "$HAKO help";
like $out, qr/^usage: /;

done_testing;

