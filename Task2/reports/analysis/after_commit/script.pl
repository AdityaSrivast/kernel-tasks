#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Path::Tiny;

#read the aggregated output
my $dir_in = path("./../../after_commit/");
my $file_in = $dir_in->child("after_commit.txt");
my $file_in_handle = $file_in->openr_utf8();

#write output summary
my $dir_out = path("./");
my $file_out = $dir_out->child("summary_after_commit.txt");
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

  # to ensure reading only error or warning messages/lines
  if($prefix eq "ERROR" || $prefix eq "WARNING") {

    my $type = $arr[1]; # holds the type of error or warning
    if(substr($type,0,1) ne " ") {
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
}

my @err_keys = keys %errors;
my $err_size = @err_keys;
$file_out_handle->print("Total errors recorded: ", $error_count);
$file_out_handle->print("\n","Total distinct errors recorded: ", $err_size);

my @warn_keys = keys %warnings;
my $warn_size = @warn_keys;
$file_out_handle->print("\n\n", "Total warnings recorded: ", $warning_count);
$file_out_handle->print("\n","Total distinct warnings recorded: ", $warn_size);

# find out which among errors and warnings is more common and by what ration
$file_out_handle->print("\n\n","Total Errors/Warnings ration recorded: ", ($error_count/$warning_count));
$file_out_handle->print("\n","Distinct Errors/Warnings ration recorded: ", ($err_size/$warn_size));

$file_out_handle->print("\n\n","Most common Error(s): ");
foreach my $err_type(keys %errors) {
  if($errors{$err_type}==$error_max) {
    $file_out_handle->print("\n", $err_type,", Frequency: ", $error_max);
  }
}
$file_out_handle->print("\n", "Ration of its(their) occurance among errors: ", $error_max/$error_count);

$file_out_handle->print("\n\n","Most common Warning(s): ");
foreach my $warn_type(keys %warnings) {
  if($warnings{$warn_type}==$warning_max) {
    $file_out_handle->print("\n", $warn_type,", Frequency: ", $warning_max);
  }
}
$file_out_handle->print("\n", "Ration of its(their) occurance among warnings: ", $warning_max/$warning_count);

$file_out_handle->print("\n\n", "COUNT OF ALL WARNINGS AND ERRORS:\n");

$file_out_handle->print("\n", "WARNINGS:\n");
foreach my $warn_type(sort {$warnings{$a} <=>  $warnings{$b}} keys %warnings) {
  $file_out_handle->print("\n", $warn_type,", Frequency: ", $warnings{$warn_type});
}

$file_out_handle->print("\n\n", "ERRORS:\n");
foreach my $err_type(sort {$errors{$a} <=>  $errors{$b}} keys %errors) {
  $file_out_handle->print("\n", $err_type,", Frequency: ", $errors{$err_type});
}

print "Summary Generated\n";
