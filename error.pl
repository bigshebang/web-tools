#!/usr/bin/perl -w
#analyze errors on web server

my $errorLog = "/var/log/httpd/error_log";
my @lines = `cat $errorLog`;
chomp @lines;

#create a hash of arrays? or just have key be this "name of keyx" where x is incremented for each one and we keep track of how many
#keys we have for a certain value

# my @test = ("index one", "index two", "number 3", "number 4", "numba fiveee");
# my $val = 1;
# my $val2 = 3;

# print "@test[$val,$val2] \n";

for (my $i = 0; $i <= $#lines; $i++)
{
	if($lines[$i] !~ /.*\[error\].*/){
		splice(@lines, $i, 1);
		$i--;
	}
}

# for $line (@lines)
# {
	
# }
