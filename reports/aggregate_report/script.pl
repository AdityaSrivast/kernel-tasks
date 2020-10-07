#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;

# write output to file
my $dir = path("./");
my $file = $dir->child("generated_aggr.txt");
my $file_handle = $file->openw_utf8();

# run checkpatch
print "Generating Report...\n";
my $output = `./scripts/checkpatch.pl --show-types commits.log`;
$file_handle->print($output);
print "Report successfully generated at '", $file, "'\n";
