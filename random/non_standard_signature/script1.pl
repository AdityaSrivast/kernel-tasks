#!/usr/bin/perl
# your code goes here
use strict;
use warnings;
use autodie;
use Path::Tiny;

my $dir_out = path("./");
my $file_out = $dir_out->child("min_dists.txt");
my $file_out_handle = $file_out->openw_utf8();

sub get_min {
	my (@arr) = @_;
	my $len = scalar @arr;
	if((scalar @arr) < 1) {
		# if underflow return
		return;
	}
	my $min = $arr[0];
	for my $i (0 .. ($len-1)) {
		if ($arr[$i] < $min) {
			$min = $arr[$i];
		}
	}
	return $min;
}

sub get_edit_distance {
	my ($str1, $str2) = @_;
	my $len1 = length($str1);
	my $len2 = length($str2);
	# two dimensional array storing minimum edit distance
	my @distance;
	for my $i (0 .. $len1) {
		for my $j (0 .. $len2) {
			if ($i == 0) {
				$distance[$i][$j] = $j;
			}
			elsif ($j == 0) {
				$distance[$i][$j] = $i;
			}
			elsif (substr($str1, $i, 1) eq substr($str2, $j, 1)) {
				$distance[$i][$j] = $distance[$i - 1][$j - 1];
			}
			else {
				my $dist1 = $distance[$i][$j - 1]; #insert distance
				my $dist2 = $distance[$i - 1][$j]; # remove
				my $dist3 = $distance[$i - 1][$j - 1]; #replace
				$distance[$i][$j] = 1 + get_min($dist1, $dist2, $dist3);
			}
		}
	}
	return $distance[$len1][$len2];
        # DEBUGGING
	# print "distance matrix:\n";
	# for my $i (0 .. $len1) {
	# 	for my $j (0 .. $len2) {
	# 		print $distance[$i][$j]." ";
	# 	}
	# 	print "\n";
	# }
	# print $distance[$len1][$len2]."\n";
}

sub get_standard_signature {
	my ($sign_off) = @_;
	$sign_off = lc($sign_off);
	$sign_off =~ s/\-//g; # to match with formed hash
	$file_out_handle->print("For: $sign_off\n");
	my %standard_signature_tags = (
		'signed-off-by:' => 20,
		'co-developed-by:' => 20,
		'acked-by:' => 20,
		'tested-by:' => 20,
		'reviewed-by:' => 20,
		'reported-by:' => 20,
		'suggested-by:' => 20,
		'to:' => 20,
		'cc:' => 20,
	);
	# setting default values
	my $standard_signature = 'signedoffby';
	my $min_edit_distance = 20;
	my $edit_distance;
	foreach my $signature (keys %standard_signature_tags) {
		$signature =~ s/\-//g;
		$edit_distance = get_edit_distance($sign_off, $signature);
		if ($edit_distance < $min_edit_distance) {
			$min_edit_distance = $edit_distance;
			$standard_signature = $signature;
		}
		$file_out_handle->print("$signature => $edit_distance\n");
	}
	
	$file_out_handle->print("\nPredicted Standard signature: $standard_signature\n");
	$file_out_handle->print("For edit distance: $min_edit_distance\n");
        $file_out_handle->print("\n\n****************************************\n");

}

my @arr = qw(Debugged-by: Requested-by: Co-authored-by: Originally-by: Analyzed-by: Bisected-by: Reviwed-by: Improvements-by: Generated-by: Original-patch-by: Diagnosed-by: Inspired-by: Noticed-by: Reviewd-by: Verified-by: Singed-off-by: Okay-ished-by: Based-on-a-patch-by: Based-on-patch-by: Original-by: Root-caused-by: Signed-of-by: Acked-for-MFD-by: Based-on-work-by: Based-on-patches-by: Proposed-by: Analysed-by: Reviewed-off-by: Reported-and-bisected-by: Fixed-by: Rewieved-by: Signed-off--by: Revieved-by: Celebrated-by: Suggestions-by: Pointed-out-by: Reivewed-by: Reported-and-analyzed-by: Spotted-by: Signef-off-by: Reported-and-debugged-by: Designed-by: Test-by: Acked_by: Pointed-at-by: Ranted-by: Signed-off-by-by: Investigated-by: Reported-and-test-by: Fscked-up-by: Original-path-by: Reported-by-by: Reporetd-by: Reviewed--by: Evaluated-by: No-objection-from-me-by: Sugested-by: Suggested--by: Bug-actually-spotted-by: Repoted-by: Decoded-by: Niced-by: Repored-and-bisected-by: Rported-by: Acked-off-by: eigned-off-by: Reveiwed-by: igned-off-by: Tested-by-by: Sugessted-by: Epic-brown-paper-bag-by: Discovered-by: Rewiewed-by: Teste-by: Patiently-pointed-out-by: Signee-off-by: -By: Fixes-by: Cleaned-up-by: Signen-off-by: Looks-ok-by: Fix-creation-mandated-by: Brown-paper-bag-by: Submitted-by: Reported-and-fixed-by: eported-by: Reviewedy-by: Just-do-it-by: Scripted-by: Siganed-off-by: Ackedy-by: Review-by: Tweeted-by: Fairly-blamed-by: Original-written-by: Ack-by: Screwed-up-by: Despised-by: Acked-again-by: Nitpicked-by: Reported-and-reviwed-by: Reorted-by: Suggsted-by: Reviwed-By: Authored-by: Bonus-points-awarded-by: Reported-and-Inspired-by: Reviewed-by-off-by: Tested-off-by:);
foreach(@arr) {
	# print "$_ :\n";
	get_standard_signature($_);
	$file_out_handle->print("\n\n");
}