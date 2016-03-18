#!/usr/bin/perl

# Update apt keys, output number of keys changed

`apt-key update 2>&1`;

s/.+gpg: Total number processed:\s+(\d+)\ngpg:\s+unchanged:\s(\d+)//s;

print $1 - $2;
