
package Crawler;

use strict;
use File::Path;

use constant USERAGENT => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.7) Gecko/2009030503 Fedora/3.0.7-1.fc10 Firefox/3.0.7";
use constant EXECUTE => "robots=off";
use constant COOKIES => "cookies.txt";
use constant DIR => ".";

use constant PROGRAM => 'wget';

sub new
{
	my $class = shift;
	my %args = @_;

	bless {
		url => $args{url},
		file => $args{file},
		param => $args{param},

		useragent => $args{useragent} || USERAGENT,
		execute => $args{execute} || EXECUTE,

		cookies => $args{cookies} || COOKIES,
		load_cookies => $args{load_cookies} || 0,
		save_cookies => $args{save_cookies} || 0,

		dir => $args{dir} || DIR,
		debug => $args{debug} || 1,

		program => $args{program} || PROGRAM,

	}, $class;
}

sub browse
{
	my ($self, $url, $file, $param) = @_;
	
	if($url) { $self->url($url); }
	if($file) { $self->file($file); }
	if($param) { $self->param($param); }

	if(!(-e $self->dir)) { mkpath($self->dir); }

	if($self->debug) { print "\n\n" . $self->command . "\n\n"; }
			
	system($self->command);
}

sub command
{
	my $self = shift;

	my ($url, $file, $param, $useragent, $execute, $load_cookies, $save_cookies, $program);

	if($self->url)
	{
		$url = "\"" . $self->url . "\""; 
	}

	if($self->file) 
	{ 
		$file = "--output-document \"" . $self->dir . "\/" .  $self->file . "\""; 
	}

	if($self->param) 
	{ 
		$param = $self->param;
	}

	if($self->useragent) 
	{ 
		$useragent = "--user-agent \"" . $self->useragent . "\"";
	}

	if($self->execute) 
	{ 
		$execute = "--execute \"" . $self->execute . "\"";
	}

	if($self->cookies && $self->load_cookies)
	{
		$load_cookies = " --load-cookies \"" . $self->dir . "\/" .  $self->cookies . "\"";
	}

	if($self->cookies && $self->save_cookies)
	{
		$save_cookies = " --save-cookies \"" . $self->dir . "\/" .  $self->cookies . "\"";
	}

	return $self->program . " $execute $useragent $load_cookies $save_cookies $url $file $param";		
}

sub find2
{
	my ($self, $file, $regex, $oneonly, $makeurl, $removeduplicates, $sorted, $reversed) = @_;
	my (@contents, $contents, @result);

	open(file, $file);
	@contents = <file>;
	close(file);
		
	$contents = join("", @contents);
	#$contents =~ s/\n//ig;		


	@result = ($contents =~ /$regex/ig);

	if($sorted)
	{
		@result = sort(@result);
	}		

	if($removeduplicates)
	{
		@result = $self->removeduplicates(@result);
	}		


	if($reversed)
	{
		@result = reverse(@result);
	}

	if($makeurl)
	{
		@result = $self->makeurl(@result);
	}
	
	
	if($oneonly)
	{
		return shift(@result);
	}
	else
	{
		return @result;
	}		
}


sub find
{
	my ($self, $file, $regex, $oneonly, $makeurl, $removeduplicates, $sorted, $reversed) = @_;
	my (@contents, $contents, @result);

	open(file, $self->dir . "\/" . $file);
	@contents = <file>;
	close(file);
		
	$contents = join("", @contents);
	$contents =~ s/\n//ig;		


	@result = ($contents =~ /$regex/ig);

	if($sorted)
	{
		@result = sort(@result);
	}		

	if($removeduplicates)
	{
		@result = $self->removeduplicates(@result);
	}		


	if($reversed)
	{
		@result = reverse(@result);
	}

	if($makeurl)
	{
		@result = $self->makeurl(@result);
	}
	
	
	if($oneonly)
	{
		return shift(@result);
	}
	else
	{
		return @result;
	}		
}

sub removeduplicates
{
	my $self = shift(@_);

	my (%seen, @newarray);

	foreach (@_)
	{
		push @newarray, $_ unless $seen{$_};
		$seen{$_}++;
	}

	return @newarray;
}

sub makeurl
{
	my ($self) = shift(@_);
	my @url = @_;
	my @url_new;

	foreach my $url(@url)
	{
		$url =~ s/\&amp\;/\&/ig;
		push(@url_new, $url);
	}

	if(scalar(@url_new) == 1)
	{
		return shift(@url_new);
	}
	else
	{
		return @url_new;			
	}
}

sub url
{
	my $self = shift;
	$self->{url} = shift if @_;
	$self->{url};
}	

sub file
{
	my $self = shift;
	$self->{file} = shift if @_;
	$self->{file};
}	

sub param
{
	my $self = shift;
	$self->{param} = shift if @_;
	$self->{param};
}	

sub execute
{
	my $self = shift;
	$self->{execute} = shift if @_;
	$self->{execute};
}	

sub useragent
{
	my $self = shift;
	$self->{useragent} = shift if @_;
	$self->{useragent};
}	

sub cookies
{
	my $self = shift;
	$self->{cookies} = shift if @_;
	$self->{cookies};
}

sub load_cookies
{
	my $self = shift;
	$self->{load_cookies} = shift if @_;
	$self->{load_cookies};
}

sub save_cookies
{
	my $self = shift;
	$self->{save_cookies} = shift if @_;
	$self->{save_cookies};
}		

sub dir
{
	my $self = shift;
	$self->{dir} = shift if @_;
	$self->{dir};
}		

sub debug
{
	my $self = shift;
	$self->{debug} = shift if @_;
	$self->{debug};
}

sub program
{
	my $self = shift;
	$self->{program} = shift if @_;
	$self->{program};
}

1;

