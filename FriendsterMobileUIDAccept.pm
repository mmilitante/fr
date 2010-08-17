package FriendsterMobileUIDAccept;

use strict;
use DBI;

use constant PROGRAM_AUTO_ACCEPT => 'perl friendster-mobile-friend-auto-accept.pl';

sub new
{
	my $class = shift;
	my %args = @_;

	bless {
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
	$self->browse_extreme();
}

sub browse
{
	my ($self, @uid) = @_;
	my ($uid, $sth, $sql);

	foreach $uid(@uid)
	{
		$sql = "insert ignore into browsed(uid) values ('$uid');";
		$sth = $self->{dbh}->prepare($sql);
		$sth->execute();
	
	}
}

sub browse_extreme
{
	my ($self, @country) = @_;

	my ($sth, $ref, $uid, $sql, $count);

	
	$sql = "select * from (select * from collected order by seen desc limit 1000) as x order by rand();";
	#print($sql);

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
			$self->tech_random_browse($uid);
			$self->browse($uid);
		}
	}
}

sub tech_random_browse
{
	my ($self, $uid) = @_;

	my ($sth, $ref, $sql, $email, $password, $command);

	$sql = "select * from bots order by rand();";
	#print("$sql\n");

	$sth = $self->{dbh}->prepare($sql);
	$sth->execute();
	
	bot:while ($ref = $sth->fetchrow_hashref()) 
	{
		$email = $ref->{'email'};
		$password = $ref->{'password'};

		if($email)
		{		
			#last bot;
			$command = PROGRAM_AUTO_ACCEPT . " $email $password";
			print("$command\n");
			system($command);
		}	
	}

	$sth->finish();
}

sub browsed
{
	my ($self, $target) = @_;

	my ($sth, $ref, $uid, $sql);

	$sql = "select * from browsed where uid = '$target';";

	$sth = $self->{dbh}->prepare($sql);
	$sth->execute();
	
	while ($ref = $sth->fetchrow_hashref()) 
	{
		$uid = $ref->{'uid'};
		
	}

	$sth->finish();

	return $uid;
}

1;
