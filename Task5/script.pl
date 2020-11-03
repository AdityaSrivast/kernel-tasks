#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;

#read before_commit report
my $dir_in_bef = path("./../Task4/");
my $file_in_bef = $dir_in_bef->child("after_patch_report.txt");
my $file_in_handle_bef = $file_in_bef->openr_utf8();

#read after_commit report
# my $dir_in_af = path("./../../../");
# my $file_in_af = $dir_in_af->child("after_patch_report.txt");
# my $file_in_handle_af = $file_in_af->openr_utf8();

#write output to summary_relative.txt
my $dir_out = path("./");
my $file_out = $dir_out->child("summary_detail.txt");
my $file_out_handle = $file_out->openw_utf8();

print "Analysing the aggregated data...\n";

# variables for storing before commit messages
my %warning_msgs_bef;
my $warning_count_bef=0;

# after commit variables
my %warning_msgs_af;
my $warning_count_af=0;

my $str;
my $flag=0;
my $id;
my $flag1=0;

while(my $line = $file_in_handle_bef->getline()) {
  if($flag1 || $flag || $line =~ /WARNING:BAD_SIGN_OFF: Duplicate signature/) {
    if($flag==0) {
      $flag=3;
    }

    if($flag==1) {
      my @arr=split(':',$line);
      $str = $arr[0];
      if($str =~ /(?:acked-by|tested-by|reported-by|reviewed-by|cc)/i) {
        $flag1=1;
      }
    }

    if($flag1) {
      if($line =~ /Commit ([a-z0-9]+)\s*/) {
        $id=$1;
        my $out = `git show $id`;
        $file_out_handle->print("$out\n");
      }
    }
    $flag-=1;
    if($flag==0) {
      $warning_msgs_bef{$str}++;
      $warning_count_bef++;
      $str='';
    }
  }
}


# foreach my $warn_msg(keys %warning_msgs_bef) {
#     $file_out_handle->print("$warn_msg -- $warning_msgs_bef{$warn_msg}\n");
# }


print "Summary Generated\n";
