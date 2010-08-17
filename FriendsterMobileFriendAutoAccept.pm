package FriendsterMobileFriendAutoAccept;

use strict;
use Crawler;
use File::Path;
use Switch;


use constant USERAGENT => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko/2009032713 Fedora/3.0.8-1.fc10 Firefox/3.0.8";

use constant URL_BASE => "http://www.friendster.com";
use constant URL_LOGIN => URL_BASE . "/login.php";
use constant URL_PROFILE => "http://profiles.friendster.com";

use constant FILE_BASE => "file_base.htm";
use constant FILE_LOGIN => "file_login.htm";
use constant FILE_PROFILE => "file_profile.htm";

use constant DIR => ".";
use constant REGEX_SIGN_IN => 'Log Out';
#use constant WGET_OPTIMIZE => '--connect-timeout=1 --read-timeout=60 --no-dns-cache -t3';
use constant WGET_OPTIMIZE => '--connect-timeout=60 --read-timeout=60 -t1 --keep-session-cookies';

use constant PROGRAM_CUSTOM => './wget';

use constant URL_FRIENDS_ACCEPT => URL_BASE . "/friendrequests.php";
use constant FILE_FRIENDS_ACCEPT => "file_friends_accept.htm";
use constant REGEX_ERROR => 'ERROR';

use constant URL_FRIENDS_REQUESTS => URL_BASE . "/friendrequests.php";
use constant FILE_FRIENDS_REQUESTS => "file_friends_requests.htm";
use constant REGEX_FRIENDS_ACCEPT_UID => 'http\:\/\/profiles\.friendster\.com/(\d+)';

sub new
{
	my $class = shift;
	my %args = @_;

	bless {
		email => $args{email},
		password => $args{password},

		cookies => $args{cookies} || "cookie_" . $args{email} . ".txt",
		dir => $args{dir} || $args{email} || DIR,

		bug_retry => $args{bug_retry} || 3,
		bug_count => $args{bug_count} || 0,
		
		crawler => Crawler->new(
			useragent => USERAGENT,
			#program => PROGRAM_CUSTOM,
		),

		crawler_login => Crawler->new(
			useragent => USERAGENT,
			#program => PROGRAM_CUSTOM,
		),


	}, $class;
}

sub test
{
	my ($self) = @_;
	
	$self->login();
}

sub auto_accept_friends_requests
{
	my ($self) = @_;
	my ($uid, @uid, @error);

	@uid = (1);
	
	while(@uid)
	{
		$self->browse(URL_FRIENDS_REQUESTS, FILE_FRIENDS_REQUESTS);
		@uid = $self->{crawler}->find(FILE_FRIENDS_REQUESTS, REGEX_FRIENDS_ACCEPT_UID, 0, 0, 1);

		if (@uid)
		{
			@error = $self->accept_friends_requests(@uid);
			if(@error) { last; }
		}
	}
}

sub accept_friends_requests
{
	my ($self, @uid) = @_;
	my (@error);

	foreach my $uid(@uid)
	{
		$self->browse(URL_FRIENDS_ACCEPT, FILE_FRIENDS_ACCEPT, "--post-data \"requests[]=$uid&formid=&action=approve\"");
		@error = $self->{crawler}->find(FILE_FRIENDS_ACCEPT, REGEX_ERROR, 0, 0, 1);
		if(@error) { last; }
	}
	
	return(@error);
}

sub login
{
	my ($self, $email, $password) = @_;
	
	if($email) { $self->email($email); }
	if($password) { $self->password($password); }

	$self->{crawler_login}->load_cookies(0);
	$self->{crawler_login}->save_cookies(1);
	$self->{crawler_login}->cookies($self->cookies);
	$self->{crawler_login}->dir($self->dir);

	$self->{crawler}->load_cookies(1);
	$self->{crawler}->save_cookies(0);
	$self->{crawler}->cookies($self->cookies);
	$self->{crawler}->dir($self->dir);

	$self->{crawler_login}->browse(URL_LOGIN, FILE_LOGIN, $self->wget_login . " " . WGET_OPTIMIZE);
}

sub wget_login
{
	my $self = shift;
	
	my $username = $self->email;
	my $password = $self->password;

	return "--post-data \"_submitted=1&next=%2F&tzoffset=-480&email=$username&password=$password&btnLogIn=Log+In\"";				
}

sub browse
{
	my $self = shift;

	$self->{crawler}->load_cookies(1);
	$self->{crawler}->save_cookies(0);
	$self->{crawler}->cookies($self->cookies);
	$self->{crawler}->dir($self->dir);

	# patch
	push(@_, WGET_OPTIMIZE);

	$self->{crawler}->browse(@_);

	if($self->bug_count < $self->bug_retry)
	{
		if(!($self->{crawler}->find(@_[1], REGEX_SIGN_IN, 1)))
		{
			$self->bug_count($self->bug_count + 1);

			$self->login();
			$self->browse(@_);
		}
	}
	else
	{
		$self->bug_count(0);
	}
}

sub email
{
	my $self = shift;
	$self->{email} = shift if @_;
	$self->{email};
}

sub password
{
	my $self = shift;
	$self->{password} = shift if @_;
	$self->{password};
}

sub cookies
{
	my $self = shift;
	$self->{cookies} = shift if @_;
	$self->{cookies};
}

sub dir
{
	my $self = shift;
	$self->{dir} = shift if @_;
	$self->{dir};
}

sub url_encode
{
	my ($self, $str) = @_;
	$str =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
	return $str;
}

sub url_decode
{
	my ($self, $str) = @_;
	$str =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
	return $str;
}

sub bug_retry
{
	my $self = shift;
	$self->{bug_retry} = shift if @_;
	$self->{bug_retry};
}

sub bug_count
{
	my $self = shift;
	$self->{bug_count} = shift if @_;
	$self->{bug_count};
}

sub urlencode
{
	my($self, $contents) = @_;

	$contents =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
	return $contents;	
}
1;
