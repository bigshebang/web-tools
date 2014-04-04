#!/usr/bin/perl -w
#analyze access to our web server
use strict;

#~constants
my $accessLog = "/var/log/httpd/access_log";
my $siteName = "www.yoursite.com"

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

print "WEB LOG REPORT FOR $siteName by Luke Matarazzo\n";
print "=" x 50 . "\n";
print "Report covers period from " . $initialDate . " at " . $initialTime . " to " . $finalDate . " at " . $finalTime . "\n";
print "There were " . $hits . " hits.\n";
