#!/usr/bin/perl -w
use strict;

print "converting language_strings.txt to language_strings.rev\n";

open my $fr, "<", "language_strings.txt" or die "failed to open language_strings.txt: $!\n";
open my $fw, ">", "language_strings.rev" or die "failed to open language_strings.rev: $!\n";

print $fw "USE provisioning;\n\n";
print $fw "TRUNCATE TABLE language_strings;\n\n";
print $fw "INSERT INTO language_strings (code, language, string) VALUES\n";
my $first = 1;
while(<$fr>) {
	chomp;
	my ($id, $code, $lang, $str) = /^(\S+)\s+(\S+)\s+(\S+)\s+(.+)$/;
	next unless (defined $id && defined $code && defined $lang && defined $str);
	print $fw ",\n" unless $first;
	print $fw "('$code', '$lang', '$str')";
	$first = 0;
}
print $fw ";\n";

close $fr;
close $fw;

print "done\n";
