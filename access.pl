#!/usr/bin/perl -w
#analyze access to our web server
# TO DO LIST
# Allow user to specify location of access log file
# Allow user to get results between a certain period of time

if($#ARGV > -1 && ($ARGV[0] eq "-h" || $ARGV[0] eq "--help")){
	print "Sample usage: ./access.pl [ACCESS_LOG] [options]\n";
	exit 0;
}

my $accessLog = "/var/log/httpd/access_log";

if($ARGV[0]){
	$accessLog = $ARGV[0];
} else{
	print "Enter location of your access log file: ";
	$accessLog = <>;
	chomp $accessLog;
}

my $hits = `wc -l < $accessLog`;
chomp $hits;
my $firstLine = `head -1 $accessLog`;
my $lastLine = `tail -1 $accessLog`;
my $initialDate;
my $initialTime;
if($firstLine =~ /.*\[(\d+\/\w+\/\d+):(\d.+)\s\-\d/)
{
        $initialDate = $1;
        $initialTime = $2;
        $initialDate =~ s/\//-/g;
}

my $finalDate;
my $finalTime;

if($lastLine =~ /.*\[(\d+\/\w+\/\d+):(\d.+)\s\-\d/)
{
        $finalDate = $1;
        $finalTime = $2;
        $finalDate =~ s/\//-/g;
}

print "WEB LOG REPORT by Luke Matarazzo\n";
print "=" x 50 . "\n";
print "Report covers period from " . $initialDate . " at " . $initialTime . " to " . $finalDate . " at " . $finalTime . "\n";
print "There were " . $hits . " hits.\n";
