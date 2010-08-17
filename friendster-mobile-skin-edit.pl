#!/usr/bin/perl

use strict;
use FriendsterMobileProfileBrowser;

use vars qw(
	$crawler
	$email
	$password
	$dir
	$skinid
	$wget_add_media
);

use constant URL_ADD_MEDIA => 'http://www.friendster.com/addmedia.php';
use constant FILE_ADD_MEDIA => 'file_add_media.htm';

$email = shift(@ARGV);
$password = shift(@ARGV);
$dir = shift(@ARGV) || rand();
$skinid = shift(@ARGV) || int(rand() * 200);

$crawler = FriendsterMobileProfileBrowser->new(
	email => $email,
	password => $password,
	dir => "$email/" . $dir,
);

$wget_add_media = "--post-data \"action=addskin&skintype=profileskinID&skinid=$skinid&next=editskin.php&nsc=1521\"";

$crawler->browse(URL_ADD_MEDIA, FILE_ADD_MEDIA, $wget_add_media);

#/addmedia.php?action=addskin&skintype=profileskinID&skinid=144&next=editskin.php&nsc=1521

