#!/usr/bin/perl
use v5.24;
our $VERSION = "0.5";

use Getopt::Long qw{ GetOptionsFromArray :config posix_default };
use Cwd 'abs_path';

use constant {
    SYS_unshare => 272,
    SYS_mount => 165,
    MS_BIND => 4096,
    CLONE_NEWNS => 0x20000,
    CLONE_NEWUSER => 0x10000000,
    CLONE_NEWNET => 0x40000000,
};

sub usage {
    warn "usage: $0 [-n] <fake-home-dir> <command...>\n";
    exit 64 unless @_;
    exit 0;
}

sub run {
    my $NS = CLONE_NEWUSER|CLONE_NEWNS;
    GetOptionsFromArray(\@_,
        "help|h|?" => \&usage,
        "net|n" => sub { $NS |= CLONE_NEWNET },
    ) or usage();
    my ($boxpath, @cmd) = @_;
    usage() unless $boxpath and @cmd;
    my $box = abs_path($boxpath) or die "invalid directory $boxpath\n";
    chdir $box or die "cannot enter $box: $!\n";

    my $uid = $>;
    my ($gid) = split " ", $);
    syscall(SYS_unshare, $NS)==0 or die "failed to unshare: $!\n";
    map_my_id($uid, $gid);
    bind_mount($box, $ENV{HOME});
    chdir or die "cannot go home: $!\n";
    exec @cmd;
    die "exec failed: $!\n";
}

sub bind_mount {
    my ($src, $tgt) = @_;
    my $dummy = "ignore me";
    syscall(SYS_mount, $src, $tgt, $dummy, MS_BIND, $dummy)==0 or die "failed to mount: $!\n";
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

run(@ARGV);

__END__

=encoding utf-8

=head1 NAME

App::Hako - keep apps away from your home

=head1 SYNOPSIS

    hako <fake-home-dir> <command-to-run...>

=head1 DESCRIPTION

Hako is an extremely simple container that replaces your $HOME directory with another separate directory (that may be within your current $HOME), so you can run another
program while preventing it from seeing or touching any of your files in $HOME.

=head1 QUESTIONS?

=head2 Could I not just change $HOME?

Setting your $HOME environment variable to a different directory would have a similar effect, but any program that checks the passwd file would find your real $HOME.

It also wouldn't isolate your network, which is another feature of Hako that I haven't mentioned yet.

=head2 Why did you write this in Perl? Why not Go or Python or C or something else?

It started as teaching material called "Build your own container runtime in 20 lines of code", and I was only able to hit the 20 lines of code target in Perl.

(It's slightly more than 20 lines of code now.)

=head1 LICENSE

Copyright (C) Marty Pauley.

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

Marty Pauley E<lt>marty@martian.orgE<gt>

=cut

