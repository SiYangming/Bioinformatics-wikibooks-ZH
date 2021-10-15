#!/usr/bin/perl
# 
# Exercise 10.4
# 
# Design a module of subroutines to handle the following kinds of data: a flat file 
# containing records consisting of gene names on a line and extra information of any 
# sort on succeeding lines, followed by a blank line. Your subroutines should be able 
# to read in the data and then do a fast lookup on the information associated with a 
# gene name. You should also be able to add new records to the flat file. Now reuse 
# this module to build an address book program.
#

# Data file for exercise 10.4

use strict;
use warnings;

sub readdatabase {
	my($dbfile) = @_;

	# Open the database file

	unless(open(DATAFILE, "<$dbfile")) {
		print "Cannot open data file $dbfile\n";
		exit;
	}
	
	my %database = ();
	
	# Set input separator.
	# This allows us to get an entire record as one scalar value
	# A blank line is just a newline following another newline.

	$/ = "\n\n";

	# Read the data
	
	while(my $record = <DATAFILE>) {

		#
		# Get the first line as a key, and the remaining lines as the value
		#

		# Turn the scalar $record back into an array of lines
		# to get the key
		my @lines = split(/\n/, $record);
		my $key = shift @lines;

		# And turn the remaining array into a scalar for storing
		# as a value in the hash
		my $value = join("\n", @lines) . "\n";
	
		$database{$key} = $value;
	}

	close(DATAFILE);
	
	# reset input separator to normal default value
	$/ = "\n";

	return %database;
}

sub getnewrecord {

	print "Input a new record (end with a blank line):\n";
	$/ = "\n\n";
	my $newrecord = <STDIN>;
	$/ = "\n";

	return join("\n", split("\n", $newrecord)), "\n";
}

sub addrecord {
	my($dbfile, @record) = @_;

	unless(open(DATAFILE, ">>$dbfile")) {
		print "Cannot write to datafile $dbfile\n";
		exit;
	}

	print DATAFILE "\n", @record;

	close DATAFILE;
}

# Don't forget this necessary last line in a module!

1;
