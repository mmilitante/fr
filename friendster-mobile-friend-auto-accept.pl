#!/usr/bin/perl

use strict;
use FriendsterMobileFriendAutoAccept;

use vars qw(
	$friend
);

$friend = FriendsterMobileFriendAutoAccept->new(
	email => shift(@ARGV),
	password => shift(@ARGV),
);

$friend->auto_accept_friends_requests();
