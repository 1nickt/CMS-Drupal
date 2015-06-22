#!/usr/bin/env perl
use strict;
use warnings;

use TAP::Harness;
use File::Find::Rule;

use Data::Dumper;

my @tests = File::Find::Rule->file()->name('*.t')->in('.');

my %args = (
  verbosity => 1,
);

my $harness = TAP::Harness->new( \%args );
$harness->runtests(@tests);

