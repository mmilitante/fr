#!/usr/bin/perl

use strict;
use FriendsterMobileUIDCollector;

use vars qw(
	$collector
	$dir_collector
);

$dir_collector = shift(@ARGV) || rand();

while(1)
{
	$collector = FriendsterMobileUIDCollector->new(
		dir => "collector/$dir_collector",
	);
	$collector->collect_extreme();
	#sleep(60);
}
