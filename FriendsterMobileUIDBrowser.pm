package FriendsterMobileUIDBrowser;

use strict;
use DBI;

use constant PROGRAM_BROWSER => 'perl friendster-mobile-profile-browser.pl';

sub new
{
	my $class = shift;
	my %args = @_;

	bless {
		dbh => DBI->connect(
				"DBI:mysql:database=fr;host=localhost",
                 		"root", 
				"mike6629",
                 		{'RaiseError' => 1}
		),
		dir => $args{dir},

	}, $class;
}

sub test
{
	my ($self) = @_;
	$self->browse_extreme();
}

sub browse
{
	my ($self, @uid) = @_;
	my ($uid, $sth, $sql);

	foreach $uid(@uid)
	{
		$sql = "update crawled set browsed = now() where uid = '$uid';";
		$sth = $self->{dbh}->prepare($sql);
		$sth->execute();
	
	}
}

sub browse_extreme
{
	my ($self, @country) = @_;

	my ($sth, $ref, $uid, $sql, $count, $target);

	$target = 1000;

	$sql = "select * from (select * from crawled where browsed = '0000-00-00 00:00:00' limit $target) as x order by rand();";

	#print "$sql\n";
	#<STDIN>;

	$sth = $self->{dbh}->prepare($sql);
	$sth->execute();
	
	while ($ref = $sth->fetchrow_hashref()) 
	{
		$uid = $ref->{'uid'};

		if($uid)
		{
			#print("$uid\n");
			$self->browse_friends($uid);
		}
	}

	$sth->finish();
}

sub browse_friends
{
	my ($self, @uid) = @_;
	my ($uid, $page, @uid_friends, $url_friends, $sql, $sth);


	foreach $uid(@uid)
	{
		if(!$self->browsed($uid))		
		{
			#print("$uid\n");
			if($self->tech_random_browse($uid))
			{
				$self->browse($uid);
			}
			else
			{
				print "no more bots left\n";
				sleep(60);
			}
		}
		else
		{
			print("$uid\n");	
		}
	}
}

sub tech_random_browse
{
	my ($self, $uid) = @_;

	my ($sth, $ref, $sql, $email, $password, $command, $dir);

	$sql = "select * from bots where status <> 'suspended' and type = 'crawler' order by rand();";
	#print("$sql\n");

	$sth = $self->{dbh}->prepare($sql);
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

	if($email)
	{
		$dir = $self->dir;
		$command = PROGRAM_BROWSER . " $email $password $dir $uid";
		print("$command\n");
		system($command);
	}

	$sth->finish();

	return $email;
}

sub browsed
{
	my ($self, $target) = @_;

	my ($sth, $ref, $uid, $sql);

	$sql = "select * from crawled where uid = '$target' and browsed <> '0000-00-00 00:00:00';";

	$sth = $self->{dbh}->prepare($sql);
	$sth->execute();
	
	while ($ref = $sth->fetchrow_hashref()) 
	{
		$uid = $ref->{'uid'};
		
	}

	$sth->finish();

	return $uid;
}

sub dir
{
	my $self = shift;
	$self->{dir} = shift if @_;
	$self->{dir};
}

1;
