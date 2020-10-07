#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;

#read the aggregated output
my $dir_in = path("./../");
my $file_in = $dir_in->child("aggr_output.txt");
my $file_in_handle = $file_in->openr_utf8();

#write output to summary.txt
my $dir_out = path("./");
my $file_out = $dir_out->child("summary.txt");
my $file_out_handle = $file_out->openw_utf8();

print "Analysing the aggregated data...\n";

my %errors;
my %warnings;
my $error_max=0;
my $warning_max=0;
my $error_count=0;
my $warning_count=0;

while(my $line = $file_in_handle->getline()) {
  my @arr = split(':',$line);
  my $prefix = $arr[0];
  if($prefix eq "ERROR" || $prefix eq "WARNING") {
    # to ensure reading only error or warning messages/lines
    my $type = $arr[1]; # holds the type of error or warning
    # print($prefix, " ", $type, "\n");
    if($prefix eq "WARNING") {
      if(exists($warnings{$type})) {
        $warnings{$type}++;
      }
      else {
        $warnings{$type}=1;
      }
      
      if($warnings{$type}>$warning_max) {
        $warning_max=$warnings{$type};
      }
      $warning_count++;
    }
    else {
      if(exists($errors{$type})) {
        $errors{$type}++;
      }
      else {
        $errors{$type}=1;
      }

      if($errors{$type}>$error_max) {
        $error_max=$errors{$type};
      }
      $error_count++;
    }
  }
}

# print_total($error_count, %errors, "errors");
# print_total($warning_count, %warnings, "warnings");
my @err_keys = keys %errors;
my $err_size = @err_keys;
$file_out_handle->print("\n", "Total errors recorded: ", $error_count);
$file_out_handle->print("\n","Total distinct errors recorded: ", $err_size);

my @warn_keys = keys %warnings;
my $warn_size = @warn_keys;
$file_out_handle->print("\n\n", "Total warnings recorded: ", $warning_count);
$file_out_handle->print("\n","Total distinct warnings recorded: ", $warn_size);

$file_out_handle->print("\n\n","Most common Error(s): ");
foreach my $err_type(keys %errors) {
  if($errors{$err_type}==$error_max) {
    $file_out_handle->print("\n", $err_type,", Frequency: ", $error_max);
  }
}

$file_out_handle->print("\n\n","Most common Warning(s): ");
foreach my $warn_type(keys %warnings) {
  if($warnings{$warn_type}==$warning_max) {
    $file_out_handle->print("\n", $warn_type,", Frequency: ", $warning_max);
  }
}

print "Summary Generated\n";
