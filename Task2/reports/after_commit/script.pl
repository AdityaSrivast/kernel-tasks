#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;
use threads;
use threads::shared;
use Thread::Semaphore;

# to manage write operation to file in sync
# attribution: https://stackoverflow.com/a/23753617/10005848
use Fcntl qw(:flock SEEK_END);

sub lock_file {
  my ($fh) = @_;
  flock($fh, LOCK_EX) or die $!;
  seek($fh, 0, SEEK_END) or die $!;
}
sub unlock_file {
  my ($fh) = @_;
  flock($fh, LOCK_UN) or die $!;
}

# read commits from commit.log
my $dir = path("./");
my $file_in = $dir->child("commits.log");
my $file_out = $dir->child("after_commit.txt");
my $file_in_handle = $file_in->openr_utf8();
my $file_out_handle = $file_out->openw_utf8();

# to limit maximum number of threads, can be changed as per hardware availability
my $sem = Thread::Semaphore->new(25);
my $count:shared = 0;

# run checkpatch
print "Generating Report...\n";
print "Please be patient. This may take around an hour...\n";

while(my $line = $file_in_handle->getline()) {
  my @commit = split(" ", $line);
  my $commit_id = $commit[0];

  # decrement semaphore counter
  $sem->down();
  my $thread = threads->create(sub {
    my $output = `perl ./scripts/checkpatch.pl --show-types -g $commit_id`;
    lock_file($file_out_handle); # to avoid conflict of resource
    $file_out_handle->print($output, "\n");
    unlock_file($file_out_handle); # unlock once resource is used
    lock($count);
    $count--;
    $sem->up(); # increment semaphore
  });
  $thread->detach; #detach thread once work is done
  lock($count);
  $count++;
}

while($count>0) {
  sleep(1);
}

print "Report successfully generated at '", $file_out, "'\n";
