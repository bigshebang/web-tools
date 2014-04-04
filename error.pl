#!/usr/bin/perl -w
#analyze errors on web server

my $siteName = "www.yoursite.com";
my $errorLog = "/var/log/httpd/error_log";
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

print "ERROR LOG REPORT FOR $siteName by Luke Matarazzo\n";
print "=" x 50 . "\n";

for $key (keys %errors){ #loop through the hash table with each key value
	print "Error: $key\nDate\t\t\t\tClient\t\t  Message\n";
	print "-" x 70 . "\n";
	for(my $i = 0; $i < $#{$errors{$key}}; $i++){
		print "$errors{$key}[$i]{'date'}\t$errors{$key}[$i]{'client'}\t  $errors{$key}[$i]{'data'}\n";
	}
	print "\n";
}
