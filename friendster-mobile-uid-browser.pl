#!/usr/bin/perl

use strict;
use FriendsterMobileUIDBrowser;

use vars qw(
	$browser
	$dir
);

$dir = shift(@ARGV) || rand();

while(1)
{
	$browser = FriendsterMobileUIDBrowser->new(
		dir => $dir,
	);
	$browser->browse_extreme();
	#sleep(60);
}
