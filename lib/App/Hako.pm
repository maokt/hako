package App::Hako;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

BEGIN {
    require 'syscall.ph';
    # really we want to also:
    # require "linux/sched.ph";
    # require "sys/mount.ph";
    # but those headers are not in core,
    # and I haven't ran h2ph correctly yet!
    # Instead, use magic number constants for now.
}

use constant {
    MS_BIND => 4096,
    CLONE_NEWNS => 0x20000,
    CLONE_NEWUTS => 0x4000000,
    CLONE_NEWIPC => 0x8000000,
    CLONE_NEWUSER => 0x10000000,
    CLONE_NEWPID => 0x20000000,
    CLONE_NEWNET => 0x40000000,
};

sub run {
    my ($box, @cmd) = @_;
    chdir $box or die "cannot enter $box: $!\n";
    my $uid = $>;
    my ($gid) = split " ", $);
    syscall(SYS_unshare, CLONE_NEWUSER|CLONE_NEWNS);
    map_my_id($uid, $gid);
    bind_mount($box, $ENV{HOME});
    chdir or die "cannot go home: $!\n";
    exec @cmd;
    die "exec failed: $!\n";
}

sub bind_mount {
    my ($src, $tgt) = @_;
    my $dummy = "ignore me";
    syscall(SYS_mount, $src, $tgt, $dummy, MS_BIND, $dummy);
}

sub map_my_id {
    my ($uid, $gid) = @_;
    proc_write(setgroups => "deny");
    proc_write(uid_map => "$uid $uid 1");
    proc_write(gid_map => "$gid $gid 1");
}

sub proc_write ($$) {
    my ($file, $data) = @_;
    open my $pf, ">", "/proc/self/$file" or die "cannot open $file: $!\n";
    print {$pf} $data or die "cannot write to $file: $!\n";
    close $pf or die "failed to close $file: $!\n";
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Hako - keep apps away from your home

=head1 SYNOPSIS

    use App::Hako;

=head1 DESCRIPTION

App::Hako is an extremely simple container wrapper.

=head1 LICENSE

Copyright (C) Marty Pauley.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Marty Pauley E<lt>marty@martian.orgE<gt>

=cut

