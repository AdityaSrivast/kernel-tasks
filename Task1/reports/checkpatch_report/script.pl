#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;

# read commits from commit.log
# write checkpatch.pl report to report.txt
my $dir = path("./");
my $file_in = $dir->child("commits.log");
my $file_out = $dir->child("report.txt");
my $file_in_handle = $file_in->openr_utf8();
my $file_out_handle = $file_out->openw_utf8();

# run checkpatch
print "Generating Report...\n";
print "Please be patient. This may take few minutes...\n";
while(my $line = $file_in_handle->getline()) {
  my @commit = split(" ", $line);
  my $commit_id = $commit[0];
  my $output = `./scripts/checkpatch.pl -g $commit_id`;
  $file_out_handle->print($output, "\n");
}
print "Report successfully generated at '", $file_out, "'\n";
