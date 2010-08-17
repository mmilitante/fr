#!/usr/bin/perl

use strict;
use FriendsterMobileProfileBrowser;

use vars qw(
	$ref_sql_bots_installer
	$ref_sql_apps @ref_sql_apps
	$ref_sql_bots_crawler @ref_sql_bots_crawler
	$dir
	$crawler
	@api_key $api_key $api_secret $id
	$url_xml_activate $app_title $wget_activate
	$email $password $url
	$command
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

use constant SQL_BOTS_INSTALLER => "select * from bots where status <> 'suspended' and type = 'installer';";
use constant SQL_APPS => "select * from apps;";
use constant SQL_BOTS_CRAWLER => "select * from bots where status <> 'suspended' and type = 'crawler';";

$dir = shift(@ARGV) || rand();

while(1)
{
	bots_installer: foreach $ref_sql_bots_installer(&getSQLResult(SQL_BOTS_INSTALLER))
	{
		@ref_sql_apps = &getSQLResult(SQL_APPS);

		$crawler = FriendsterMobileProfileBrowser->new(
			email => $ref_sql_bots_installer->{'email'},
			password => $ref_sql_bots_installer->{'password'},
			dir => $ref_sql_bots_installer->{'email'} . "/" . $dir,
		);

		#$crawler->login();

		$crawler->browse(URL_WIDGET_MANAGE, FILE_WIDGET_MANAGE);

		@api_key = $crawler->{crawler}->find(FILE_WIDGET_MANAGE, REGEX_LINK_API_KEY);

		api_key: foreach $api_key(@api_key)
		{
			$crawler->browse(URL_WIDGET_INFO . "?api_key=$api_key", FILE_WIDGET_INFO);
			$api_secret = $crawler->{crawler}->find(FILE_WIDGET_INFO, REGEX_INPUT_API_SECRET, 1);
			$id = $crawler->{crawler}->find(FILE_WIDGET_INFO, REGEX_INPUT_ID, 1);

			if(@ref_sql_apps)
			{
				$ref_sql_apps = shift(ref_sql_apps);
				$app_title = $ref_sql_apps->{'title'};
				$url_xml_activate = $ref_sql_apps->{'url'};

				$wget_activate = "--post-data \"api_key=$api_key&api_secret=$api_secret&id=$id&type=&name=$app_title&os_url=$url_xml_activate&category=2&description=&display_name=&display_to_profile=Yes&action=edit\"";
				$crawler->browse(URL_WIDGET_INFO, FILE_WIDGET_INFO, $wget_activate);
			}
			else
			{
				last api_key;
			}

			foreach $ref_sql_bots_crawler(&getSQLResult(SQL_BOTS_CRAWLER))
			{
				$email = $ref_sql_bots_crawler->{'email'};
				$password = $ref_sql_bots_crawler->{'password'};
				$url = $ref_sql_bots_crawler->{'url'};
			
				$crawler->browse($url, FILE_PROFILE_WIDGET_TEST);
				if(!$crawler->{crawler}->find(FILE_PROFILE_WIDGET_TEST, $api_key))
				{
					$command = PROGRAM_APP_INSTALL . " $email $password $dir $api_key";
					system($command);	
				}
			}	
		}

		last bots_installer;
	}

	sleep(3600);
}

sub getSQLResult
{
	my ($sql) = @_;
	my (@ref, $ref, $dbh, $sth);

	$dbh = FriendsterMobileProfileBrowser->new();
	$sth = $dbh->{dbh}->prepare($sql);
	$sth->execute();

	while ($ref = $sth->fetchrow_hashref()) 
	{		
		push(@ref, $ref);
	}
	
	return(@ref);
}

