#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;

#read before_commit report
my $dir_in_bef = path("./../../../");
my $file_in_bef = $dir_in_bef->child("bef_patch_report.txt");
my $file_in_handle_bef = $file_in_bef->openr_utf8();

#read after_commit report
my $dir_in_af = path("./../../../");
my $file_in_af = $dir_in_af->child("after_patch_report.txt");
my $file_in_handle_af = $file_in_af->openr_utf8();

#write output to summary_relative.txt
my $dir_out = path("./");
my $file_out = $dir_out->child("summary.txt");
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

while(my $line = $file_in_handle_bef->getline()) {
  if($flag || $line =~ /WARNING:FROM_SIGN_OFF_MISMATCH/) {
    if($flag==0) {
      $flag=2;
    }

    if($flag) {
      $str.=$line;
    }
    $flag-=1;
    if($flag==0) {
      $warning_msgs_bef{$str}=1;
      $warning_count_bef++;
      $str='';
    }
  }
}

$flag=0;
$str='';
while(my $line = $file_in_handle_af->getline()) {
  if($flag || $line =~ /WARNING:FROM_SIGN_OFF_MISMATCH/) {
    if($flag==0) {
      $flag=2;
    }

    if($flag) {
      $str.=$line;
    }
    $flag-=1;
    if($flag==0) {
      $warning_msgs_af{$str}=1;
      $warning_count_af++;
      $str='';
    }
  }
}

$file_out_handle->print("DIFFERENCE OF REPEATED_WORD WARNING ON REGEX PATTERN CHANGE:\n\n");

$file_out_handle->print("WARNINGS DROPPED BY THE PATCH BUT PRESENT EARLIER:\n\n");

foreach my $warn_msg(sort {lc $a cmp lc $b} keys %warning_msgs_bef) {
  my $bef = $warning_msgs_bef{$warn_msg};
  my $af = $warning_msgs_af{$warn_msg};
  if(!$af) {
    $af=0;
  }
  if($bef!=$af) {
    $file_out_handle->print($warn_msg."\n");
  }
}

$file_out_handle->print("\n\n*************************************************\n\n");

$file_out_handle->print("\n\nWARNINGS PRESENT IN PATCH BUT ABSENT EARLIER:\n\n");
foreach my $warn_msg(sort {lc $a cmp lc $b} keys %warning_msgs_af) {
  my $bef = $warning_msgs_bef{$warn_msg};
  my $af = $warning_msgs_af{$warn_msg};
  if(!$bef) {
    $bef=0;
  }
  if($bef!=$af) {
    $file_out_handle->print($warn_msg."\n");
  }
}


print "Summary Generated\n";
