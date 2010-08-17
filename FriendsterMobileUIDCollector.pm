package FriendsterMobileUIDCollector;

use strict;
use Crawler;
use File::Path;
use DBI;
use Switch;

use constant USERAGENT => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.3) Gecko/20090909 Fedora/3.5.3-1.fc11 Firefox/3.5.3";
use constant URL_BASE => "http://www.friendster.com";
use constant FILE_FRIENDS => "file_friends.htm";
use constant FILE_PHOTOLIST => "file_photolist.htm";

use constant DIR => ".";
use constant REGEX_SIGN_IN => 'Log Out';
use constant REGEX_UID => 'http\:\/\/profiles\.friendster\.com/(\d+)';
use constant REGEX_PRIVATE_PROFILE => 'Private Profile';
use constant REGEX_FANS => '\/fans\/';

use constant WGET_OPTIMIZE => '--connect-timeout=60 --read-timeout=60 -t1 --keep-session-cookies';
#use constant WGET_OPTIMIZE => '--connect-timeout=1 --read-timeout=60 --no-dns-cache';

use constant PROGRAM_CUSTOM => './wget';

sub new
{
	my $class = shift;
	my %args = @_;

	bless {
		crawler => Crawler->new(
			useragent => USERAGENT,
			#program => PROGRAM_CUSTOM,
		),

		dir => $args{dir} || DIR,

		dbh => DBI->connect(
				"DBI:mysql:database=fr;host=localhost",
                 		"root", 
				"mike6629",
                 		{'RaiseError' => 1}),

	}, $class;
}

sub test
{
	my ($self) = @_;
	$self->collect_extreme();
}

sub collect
{
	my ($self, @uid) = @_;
	my ($uid, $sth, $sql);

	foreach $uid(@uid)
	{
		$sql = "insert ignore into crawled(uid) values ('$uid');";
		$sth = $self->{dbh}->prepare($sql);
		$sth->execute();
	}
}

sub getstarted
{
	my ($self) = @_;
	my ($url_photolist, $page, @uid, $uid, $sth, $sql);
	
	$page = 0;
	@uid = (1);

	while(@uid)
	{
		$url_photolist = URL_BASE . "/photolist.php?list=mostrecent&page=$page";
		$self->browse($url_photolist, FILE_PHOTOLIST);
		
		@uid = $self->{crawler}->find(FILE_PHOTOLIST, REGEX_UID, 0, 0, 1);

		$self->collect(@uid);

		$page++;
	}
}

sub collect_extreme
{
	my ($self, @country) = @_;

	my ($sth, $ref, $uid, $sql, $count);

	
	$sql = "select * from (select * from crawled order by collected desc limit 1000) as x order by rand();";

	$sth = $self->{dbh}->prepare($sql);
	$sth->execute();
	
	while ($ref = $sth->fetchrow_hashref()) 
	{
		$uid = $ref->{'uid'};

		if($uid)
		{
			$self->collect_friends($uid);
		}
	}

	if(!$ref)
	{
		$self->getstarted();
	}	

	$sth->finish();
}

sub collect_friends
{
	my ($self, @uid) = @_;
	my ($uid, $page, @uid_friends, $url_friends, $sql, $sth, $fans);


	foreach $uid(@uid)
	{
		$page = 0;
		@uid_friends = (1);
	
		while(@uid_friends)
		{
			if(!$fans)
			{
				$url_friends = URL_BASE . "/friends/$uid/$page";
			}
			else
			{
				$url_friends = URL_BASE . "/fans/$uid/$page";
			}

			$self->browse($url_friends, FILE_FRIENDS);

			if($self->{crawler}->find(FILE_FRIENDS, REGEX_FANS, 0, 0, 1, 1))
			{
				$fans = 1;
			}
			else
			{
				$fans = 0;
			}

			@uid_friends = $self->{crawler}->find(FILE_FRIENDS, REGEX_UID, 0, 0, 1, 1);
		
			if(
				$self->{crawler}->find(FILE_FRIENDS, REGEX_PRIVATE_PROFILE, 0, 0, 1, 1) ||
				scalar(@uid_friends) == 1
			)
			{
				@uid_friends = ();
			}
			else
			{
				$self->collect(@uid_friends);
			}

			$page++;

		}

	}
}


sub browse
{
	my $self = shift;

	# patch
	push(@_, WGET_OPTIMIZE);

	$self->{crawler}->dir($self->dir);
	$self->{crawler}->browse(@_);
}

sub dir
{
	my $self = shift;
	$self->{dir} = shift if @_;
	$self->{dir};
}

1;
