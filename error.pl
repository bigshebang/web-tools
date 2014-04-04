#!/usr/bin/perl -w
#analyze errors on web server

my $siteName = "www.yoursite.com";
my $errorLog = "/var/log/httpd/error_log";
my @lines = `cat $errorLog`;
chomp @lines;

#create a hash of arrays? or just have key be this "name of keyx" where x is incremented for each one and we keep track of how many
#keys we have for a certain value

# my @test = ("index one", "index two", "number 3", "number 4", "numba fiveee");
# my $val = 1;
# my $val2 = 3;

# print "@test[$val,$val2] \n";

for (my $i = 0; $i <= $#lines; $i++){
	if($lines[$i] !~ /.*\[error\].*/){
		splice(@lines, $i, 1);
		$i--;
	}
}

my %errors; #hash of array of hashes?

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
		# $errors{}
		# my $date = $1;
		# my $client = $2;
		# my $error = $3;
		# my $data = $4;
		# print "date is '$date'\n";
		# print "client is '$client'\n";
		# print "error is '$error'\n";
		# print "data is '$data'\n";
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
