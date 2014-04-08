#!/usr/bin/perl -w
#analyze errors on web server
# TO DO LIST
# add command line options and a menu based system if no arguments given
# allow user to specify sitename and location of error log
# let user sort based on error type, date, data, and client
# let user show only one type of error (list all errors given)
# let user specify a certain period of time to show errors between

if($#ARGV > -1 && ($ARGV[0] eq "-h" || $ARGV[0] eq "--help")){
	print "Sample usage: ./error.pl [ERROR_LOG] [options]\n";
	print "\nAn exit status of 1 indicates that the given file could not be found or read properly.\n";
	exit 0;
}

my $errorLog = "/var/log/httpd/access_log";

if($ARGV[0]){
	$errorLog = $ARGV[0];
} else{
	print "Enter location of your access log file: ";
	$errorLog = <>;
	chomp $errorLog;
}

unless(-e $errorLog){ #check if the file given exists
	print STDERR "File given either does not exist or is not readable.\n";
	exit 1;
}

use Switch; #allow the use of switch case statement

my @lines = `cat $errorLog`;
chomp @lines;

for (my $i = 0; $i <= $#lines; $i++){
	if($lines[$i] !~ /.*\[error\].*/){
		splice(@lines, $i, 1);
		$i--;
	}
}

my %errors; #hash of arrays which hold pointers to hashes

for $line (@lines){
	if($line =~ /^\[(\w+\s\w+\s\d+\s\d+:\d+:\d+\s\d+)\].*\[client\s(.*)\]\s(.*?:)\s(.*)/){
		my %temp;
		chop (my $error = $3);
		$temp{'date'} = $1;
		$temp{'client'} = $2;
		$temp{'data'} = $4;
		if(exists($errors{$error})){ #if this already exists, just add to the array
			push $errors{$error}, \%temp;
		} else{
			$errors{$error}[0] = \%temp;
		}
	}
}

print "ERROR LOG REPORT by Luke Matarazzo\n";
print "=" x 50 . "\n";

for $key (keys %errors){ #loop through the hash table with each key value
	print "Error: $key\nDate\t\t\t\tClient\t\t  Message\n";
	print "-" x 70 . "\n";
	for(my $i = 0; $i < $#{$errors{$key}}; $i++){
		print "$errors{$key}[$i]{'date'}\t$errors{$key}[$i]{'client'}\t  $errors{$key}[$i]{'data'}\n";
	}
	print "\n";
}
