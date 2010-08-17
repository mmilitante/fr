package FriendsterMobileProfileBrowser;

use strict;
use Crawler;
use File::Path;
use Switch;
use DBI;

use constant USERAGENT => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko/2009032713 Fedora/3.0.8-1.fc10 Firefox/3.0.8";

use constant URL_BASE => "http://www.friendster.com";
use constant URL_LOGIN => URL_BASE . "/login.php";
use constant URL_PROFILE => "http://profiles.friendster.com";

use constant FILE_BASE => "file_base.htm";
use constant FILE_LOGIN => "file_login.htm";
use constant FILE_PROFILE => "file_profile.htm";

use constant DIR => ".";
use constant REGEX_SIGN_IN => '>Log Out<';
use constant REGEX_PLEASE_LOG_IN => 'Please enter your Email Address and Password';

#use constant WGET_OPTIMIZE => '--connect-timeout=1 --read-timeout=60 --no-dns-cache -t3';
use constant WGET_OPTIMIZE => '--connect-timeout=60 --read-timeout=60 -t1 --keep-session-cookies';

use constant PROGRAM_CUSTOM => '/home/mike/wget/wget-1.11.4/src/wget';
use constant REGEX_AUTH_V2 => 'friendster\_auth\_v2';

use constant REGEX_IS_SUSPENDED => 'That account has been suspended';

use constant REGEX_INPUT_UID => '<input type\=\"hidden\" name\=\"uid\" value\=\"(\d+)\">';

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

		crawler_fast => Crawler->new(
			useragent => USERAGENT,
			program => $args{custom_program} || PROGRAM_CUSTOM,
		),

		crawler_login => Crawler->new(
			useragent => USERAGENT,
			#program => PROGRAM_CUSTOM,
		),

		fast => $args{fast} || 1,

		custom_program => $args{custom_program} || PROGRAM_CUSTOM,

		dbh => DBI->connect(
				"DBI:mysql:database=fr;host=localhost",
                 		"root", 
				"mike6629",
                 		{'RaiseError' => 1}
		),
		
	}, $class;
}

sub test
{
	my ($self) = @_;
	
	$self->login();
}

sub browse_profile
{
	my ($self, @uid) = @_;
	my ($uid, $command);
	

	foreach $uid(@uid)
	{
		$self->{crawler_fast}->load_cookies(1);
		$self->{crawler_fast}->save_cookies(1);
		$self->{crawler_fast}->cookies($self->cookies);
		$self->{crawler_fast}->dir($self->dir);
=begin
		if($self->fast && -e $self->custom_program)
		{
			if(!(-e $self->dir . "/" . $self->cookies) || !$self->{crawler}->find($self->dir . "/" . $self->cookies, REGEX_AUTH_V2, 1))
			{
				$self->login();
			}

			$self->{crawler_fast}->browse(URL_PROFILE . "/$uid", "", "--head");
		}
=cut
		if($self->fast)
		{
			if(!(-e $self->dir . "/" . $self->cookies) || !$self->{crawler}->find($self->dir . "/" . $self->cookies, REGEX_AUTH_V2, 1))
			{
				$self->login();
			}

			$command = "curl --head -b " . $self->dir . "/" . $self->cookies . " " . URL_PROFILE . "/$uid";
			print("\n$command\n\n");
			system($command);
		}
		else
		{
			$self->browse(URL_PROFILE . "/$uid", FILE_PROFILE);
		}
	}
}

sub login
{
	my ($self, $email, $password) = @_;
	my ($sql, $sth);
	
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

	if($self->{crawler_login}->find(FILE_LOGIN, REGEX_IS_SUSPENDED, 1))
	{
		$email = $self->email;
		$password = $self->password;

		#$sql = "update bots set status = 'suspended' where email = '$email'";
		$sql = "insert into bots (email, password, status) values ('$email', '$password', 'suspended') on duplicate key update status = 'suspended';";
		$sth = $self->{dbh}->prepare($sql);
		$sth->execute();
	}

}

sub wget_login
{
	my $self = shift;
	
	my $username = $self->email;
	my $password = $self->password;

	#return "--post-data \"_submitted=1&next=%2F&tzoffset=-480&email=$username&password=$password&btnLogIn=Log+In\"";				
	return "--post-data \"_submitted=1&next=%2F&tzoffset=-480&email=$username&password=$password&rememberme=on\"";				
}

sub browse
{
	my $self = shift;
	my ($sth, $sql, $email, $password);

	$self->{crawler}->load_cookies(1);
	$self->{crawler}->save_cookies(1);
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

			if(!($self->{crawler}->find(@_[1], REGEX_INPUT_UID, 1)))
			{
				$self->login();
				$self->browse(@_);
			}
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

sub fast
{
	my $self = shift;
	$self->{fast} = shift if @_;
	$self->{fast};
}

sub custom_program
{
	my $self = shift;
	$self->{custom_program} = shift if @_;
	$self->{custom_program};
}
1;
