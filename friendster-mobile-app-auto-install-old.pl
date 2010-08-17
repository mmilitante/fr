#!/usr/bin/perl

use strict;
use FriendsterMobileProfileBrowser;

use vars qw(
	$dbh
	$sql $sth $ref $email $password $dir
	$crawler
	@api_key $api_key $api_secret $id
	$url
	$command
	$wget_activate
	$url_xml_activate
	$app_title
);

use constant URL_BASE => 'http://www.friendster.com';
use constant URL_WIDGET_MANAGE => URL_BASE . '/developer/widget_manage.php';
use constant URL_WIDGET_INFO => URL_BASE . '/developer/widget_info.php';

use constant FILE_WIDGET_MANAGE => "file_widget_manage.htm";
use constant FILE_WIDGET_INFO => "file_widget_info.htm";
use constant FILE_PROFILE_WIDGET_TEST => "file_profile_widget_test.htm";

use constant PROGRAM_APP_INSTALL => 'perl friendster-mobile-app-install.pl';
use constant REGEX_LINK_API_KEY => '<a href\=\"\/developer\/widget_info\.php\?api\_key\=(.+?)\"';

use constant REGEX_INPUT_ID => '<input type\=\"hidden\" name\=\"id\" id\=\"id\" value\=\"(\d+)\">';
use constant REGEX_INPUT_API_SECRET => '<input type\=\"hidden\" name\=\"api_secret\" id\=\"api_secret\" value\=\"(.+?)\">';

use constant URL_XML_ACTIVATE => 'http://69.73.158.164/alpha.xml';
use constant APP_TITLE => 'day';

$dir = shift(@ARGV) || rand();
$url_xml_activate = shift(@ARGV) || URL_XML_ACTIVATE;
$app_title = shift(@ARGV) || APP_TITLE;

$dbh = FriendsterMobileProfileBrowser->new();

while(1)
{
	$sql = "select * from bots where status <> 'suspended' and type = 'installer';";

	$sth = $dbh->{dbh}->prepare($sql);
	$sth->execute();

	bot:while ($ref = $sth->fetchrow_hashref()) 
	{
		$email = $ref->{'email'};
		$password = $ref->{'password'};

		if($email)
		{		
			last bot;
		}	
	}

	$crawler = FriendsterMobileProfileBrowser->new(
		email => $email,
		password => $password,
		dir => "$email/" . $dir,
	);

	$crawler->login();
	$crawler->browse(URL_WIDGET_MANAGE, FILE_WIDGET_MANAGE);

	@api_key = $crawler->{crawler}->find(FILE_WIDGET_MANAGE, REGEX_LINK_API_KEY);
	$api_key = shift(@api_key);

	if($api_key)
	{

		$crawler->browse(URL_WIDGET_INFO . "?api_key=$api_key", FILE_WIDGET_INFO);
		$api_secret = $crawler->{crawler}->find(FILE_WIDGET_INFO, REGEX_INPUT_API_SECRET, 1);
		$id = $crawler->{crawler}->find(FILE_WIDGET_INFO, REGEX_INPUT_ID, 1);

		$wget_activate = "--post-data \"api_key=$api_key&api_secret=$api_secret&id=$id&type=&name=$app_title&os_url=$url_xml_activate&category=5&description=&display_name=&display_to_profile=Yes&action=edit\"";

		$crawler->browse(URL_WIDGET_INFO, FILE_WIDGET_INFO, $wget_activate);

		$sql = "select * from bots where status <> 'suspended' and type = 'crawler';";

		$sth = $dbh->{dbh}->prepare($sql);
		$sth->execute();

		while ($ref = $sth->fetchrow_hashref()) 
		{
			$email = $ref->{'email'};
			$password = $ref->{'password'};
			$url = $ref->{'url'};

			if($email)
			{		
				$crawler->browse($url, FILE_PROFILE_WIDGET_TEST);
				if(!$crawler->{crawler}->find(FILE_PROFILE_WIDGET_TEST, $api_key))
				{
					$command = PROGRAM_APP_INSTALL . " $email $password $dir $api_key";
					print("$command\n");
					system($command);	
				}
			}	
		}
	}
sleep(60);
}
