#!/usr/bin/perl

# DistractMe
# A simple distraction script to send random links 
# Version 1.01
# Author: farmboi

use strict;
use warnings;
use Getopt::Long; #Option Support
use WebService::HipChat; #Load the Hipchat Module

my $reddit = 0;
my $imgur = 0;

my $username = 0;

my $url = 0; 
my $user = 0; 

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

my $hc = WebService::HipChat->new(auth_token => 'YOUR_HIPCHAT_TOKEN_HERE');


GetOptions ( 
             'reddit' => sub{ $reddit = 1 }, 
             'imgur' => sub{ $imgur = 1 }, 
             
            # To specify users via a flag replace username with your user and #user with the hipchat id.
            # For example:
            #'username' => sub{ $user = 12345 },             

            );


sub imgur{

	my $curl = `curl -s -I http://imgur.com/random | grep Location | awk {'print \$2'}`;

	my $find = "imgur.com\/gallery";
	my $replace = "i.imgur.com";

	$curl =~ s/$find/$replace/g;
	$url = $curl;
	$url =~ s/\s*$//g;

}

sub reddit{
	my $rlink = `curl -s -I https://www.reddit.com/r/random | grep location | awk {'print \$2'}`;
	$url = $rlink;
}

if ($imgur == 1) {
	imgur();
	$hc->send_private_msg($user, {message => "$url" });
}     

if ($reddit == 1) {

	reddit();
	$hc->send_private_msg($user, {message => "$url" });
}  
