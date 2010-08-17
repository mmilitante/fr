#!/usr/bin/perl

use strict;
use FriendsterMobileUIDAccept;

use vars qw(
	$browser
);

while(1)
{
	$browser = FriendsterMobileUIDAccept->new();
	$browser->tech_random_browse();
	sleep(60);
}
