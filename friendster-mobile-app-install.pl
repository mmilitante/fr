#!/usr/bin/perl

use strict;
use FriendsterMobileProfileBrowser;

use vars qw(
	$crawler
	$email
	$password
	@appname $appname
	$dir
	$api_key
	$authcode
	$wget_widget_add
	@error
);

use constant URL_BASE => 'http://www.friendster.com';
use constant URL_WIDGETS => 'http://widgets.friendster.com';
use constant URL_WIDGET_ADD => URL_BASE . '/widget_add.php';
use constant FILE_WIDGETS => 'file_widgets.htm';
use constant FILE_WIDGET_ADD => 'file_widget_add.htm';

use constant REGEX_INPUT_API_KEY => 'name\=\"api_key\" value\=\"(.+?)\"';
use constant REGEX_INPUT_AUTHCODE => 'name\=\"authcode\" value\=\"(.+?)\"';

$email = shift(@ARGV);
$password = shift(@ARGV);
$dir = shift(@ARGV) || rand();
@appname = @ARGV;

$crawler = FriendsterMobileProfileBrowser->new(
	email => $email,
	password => $password,
	dir => "$email/" . $dir,
);

foreach $appname(@appname)
{
	#@error = (1);
	$crawler->browse(URL_WIDGETS . "/$appname", FILE_WIDGETS);

	$api_key = $crawler->{crawler}->find(FILE_WIDGETS, REGEX_INPUT_API_KEY, 1);
	$authcode = $crawler->{crawler}->find(FILE_WIDGETS, REGEX_INPUT_AUTHCODE, 1);

	$wget_widget_add = "--post-data \"AddToProfile=On&authcode=$authcode&api_key=$api_key&src=canvas&src_user_id=&next=\"";

	#while(@error)
	{
		$crawler->browse(URL_WIDGET_ADD, FILE_WIDGET_ADD, $wget_widget_add);
		#@error = $crawler->{crawler}->find(FILE_WIDGET_ADD, 'errorbox');
	}
}
