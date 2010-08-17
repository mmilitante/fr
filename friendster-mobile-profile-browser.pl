#!/usr/bin/perl

use strict;
use FriendsterMobileProfileBrowser;

use vars qw(
	$crawler
	$email
	$password
	@uid
	$dir
);

$email = shift(@ARGV);
$password = shift(@ARGV);
$dir = shift(@ARGV);
@uid = @ARGV;

$crawler = FriendsterMobileProfileBrowser->new(
	email => $email,
	password => $password,
	dir => "$email/" . $dir,
);

$crawler->browse_profile(@uid);
