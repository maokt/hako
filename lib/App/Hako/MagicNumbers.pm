package App::Hako::MagicNumbers;
use strict;

use constant {
    SYS_unshare => 272,
    SYS_mount => 165,
    MS_BIND => 4096,
    CLONE_NEWNS => 0x20000,
    CLONE_NEWUSER => 0x10000000,
    CLONE_NEWNET => 0x40000000,
};

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw/
    SYS_unshare SYS_mount
    MS_BIND
    CLONE_NEWNS CLONE_NEWUSER CLONE_NEWNET
/;

