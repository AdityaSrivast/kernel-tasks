#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;

#read before_commit report
my $dir_in_bef = path("./../../../before_commit/");
my $file_in_bef = $dir_in_bef->child("before_commit.txt");
my $file_in_handle_bef = $file_in_bef->openr_utf8();

#read after_commit report
my $dir_in_af = path("./../../../after_patch/");
my $file_in_af = $dir_in_af->child("after_patch.txt");
my $file_in_handle_af = $file_in_af->openr_utf8();

#write output to summary_relative.txt
my $dir_out = path("./");
my $file_out = $dir_out->child("summary_relative.txt");
my $file_out_handle = $file_out->openw_utf8();

print "Analysing the aggregated data...\n";

# variables for storing before commit messages
my %errors_bef;
my %warnings_bef;
my $error_max_bef=0;
my $warning_max_bef=0;
my $error_count_bef=0;
my $warning_count_bef=0;

# after commit variables
my %errors_af;
my %warnings_af;
my $error_max_af=0;
my $warning_max_af=0;
my $error_count_af=0;
my $warning_count_af=0;

while(my $line = $file_in_handle_bef->getline()) {
  if($line =~ m/WARNING:+/) {
    my $str = $';
    my @arr = split(':',$str);
    my $type = $arr[0];
    if(substr($type,0,1) ne " ") {
      if(exists($warnings_bef{$type})) {
        $warnings_bef{$type}++;
      }
      else {
        $warnings_bef{$type}=1;
      }
      
      $warning_count_bef++;
    }
  }

  if($line=~ m/ERROR:/) {
    my $str = $';
    my @arr = split(':',$str);
    my $type = $arr[0];
    if(substr($type,0,1) ne " ") {
      if(exists($errors_bef{$type})) {
        $errors_bef{$type}++;
      }
      else {
        $errors_bef{$type}=1;
      }

      $error_count_bef++;
    }
  }
}

while(my $line = $file_in_handle_af->getline()) {
  if($line =~ m/WARNING:+/) {
    my $str = $';
    my @arr = split(':',$str);
    my $type = $arr[0];
    if(substr($type,0,1) ne " ") {
      if(exists($warnings_af{$type})) {
        $warnings_af{$type}++;
      }
      else {
        $warnings_af{$type}=1;
      }
      
      $warning_count_af++;
    }
  }

  if($line=~ m/ERROR:/) {
    my $str = $';
    my @arr = split(':',$str);
    my $type = $arr[0];
    if(substr($type,0,1) ne " ") {
      if(exists($errors_af{$type})) {
        $errors_af{$type}++;
      }
      else {
        $errors_af{$type}=1;
      }

      $error_count_af++;
    }
  }
}

$file_out_handle->print("COUNT OF ALL DISTINCT WARNINGS AND ERRORS:\n");

$file_out_handle->print("\n", "WARNING_TYPE    BEFORE_COMMIT_COUNT   AFTER_COMMIT_COUNT");
foreach my $warn_type(keys %warnings_af) {
  my $bef = $warnings_bef{$warn_type};
  my $af = $warnings_af{$warn_type};
  if(!$bef) {
    $bef=0;
  }
  if($bef!=$af) {
    $file_out_handle->print("\n", "$warn_type  $bef  $af");
  }
}
foreach my $warn_type(keys %warnings_bef) {
  my $bef = $warnings_bef{$warn_type};
  my $af = $warnings_af{$warn_type};
  if(!$af) {
    $af=0;
    $file_out_handle->print("\n", "$warn_type  $bef  $af");
  }
}

$file_out_handle->print("\n\n", "ERROR_TYPE    BEFORE_COMMIT_COUNT   AFTER_COMMIT_COUNT");
foreach my $err_type(keys %errors_af) {
  my $bef = $errors_bef{$err_type};
  my $af = $errors_af{$err_type};
  if(!$bef) {
    $bef=0;
  }
  if($bef!=$af) {
    $file_out_handle->print("\n", "$err_type  $bef  $af");
  }
}
foreach my $err_type(keys %errors_bef) {
  my $bef = $errors_bef{$err_type};
  my $af = $errors_af{$err_type};
  if(!$af) {
    $af=0;
    $file_out_handle->print("\n", "$err_type  $bef  $af");
  }
}

print "Summary Generated\n";
