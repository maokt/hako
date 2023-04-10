[![pipeline status](https://gitlab.com/maokt/hako/badges/master/pipeline.svg)](https://gitlab.com/maokt/hako/-/commits/master)

# NAME

hako - keep apps away from your home

# SYNOPSIS

    hako <fake-home-dir> <command-to-run...>

# DESCRIPTION

Hako is an extremely simple container that replaces your $HOME directory with another separate directory (that may be within your current $HOME), so you can run another
program while preventing it from seeing or touching any of your files in $HOME.

# QUESTIONS?

## Could I not just change $HOME?

Setting your $HOME environment variable to a different directory would have a similar effect, but any program that checks the passwd file would find your real $HOME.

It also wouldn't isolate your network, which is another feature of Hako that I haven't mentioned yet.

## Why did you originally write this in Perl? Why not Go or Python or C or something else?

It started as teaching material called "Build your own container runtime in 20 lines of code", and I was only able to hit the 20 lines of code target in Perl.
(It's more than 20 lines of code now.)

# LICENSE

Copyright (C) Marty Pauley.

This library is free software.
You can redistribute and/or modify the Perl scripts under the same terms as Perl itself.

# AUTHOR

Marty Pauley <marty@martian.org>
