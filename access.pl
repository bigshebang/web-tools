#!/usr/bin/perl -w
#analyze access to our web server
use strict;

my $accessLog = "/var/log/httpd/access_log";
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
        # print "1 is '$val1'\n";
        # print "2 is '$val2'\n";
}

my $finalDate;
my $finalTime;

if($lastLine =~ /.*\[(\d+\/\w+\/\d+):(\d.+)\s\-\d/)
{
        $finalDate = $1;
        $finalTime = $2;
        $finalDate =~ s/\//-/g;
        # print "1 is '$val1'\n";
        # print "2 is '$val2'\n";
}

print "WEBLOG REPORT FOR WWW.LUKE.COM by Luke Matarazzo\n";
print "=" x 50 . "\n";
print "Report covers period from " . $initialDate . " at " . $initialTime . " to " . $finalDate . " at " . $finalTime . "\n";
print "There were " . $hits . " hits.\n";
