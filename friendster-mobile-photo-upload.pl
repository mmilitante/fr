#!/usr/bin/perl

use strict;
use FriendsterMobileProfileBrowser;

use vars qw(
	$crawler
	$email
	$password
	$photo @photo
	$dir
	$curl_regnewphoto
	$command
	$uid
);

use constant URL_REG_NEW_PHOTO => 'http://www.friendster.com/regnewphoto.php';
use constant FILE_REG_NEW_PHOTO => 'file_reg_new_photo.htm';
use constant REGEX_INPUT_UID => '<input type\=\"hidden\" name\=\"uid\" value\=\"(\d+)\">';

$email = shift(@ARGV);
$password = shift(@ARGV);
$dir = shift(@ARGV) || rand();
@photo = @ARGV;

@photo = &randarray(@photo);

$crawler = FriendsterMobileProfileBrowser->new(
	email => $email,
	password => $password,
	dir => "$email/" . $dir,
);

$crawler->browse(URL_REG_NEW_PHOTO, FILE_REG_NEW_PHOTO);

$uid = $crawler->{crawler}->find(FILE_REG_NEW_PHOTO, REGEX_INPUT_UID, 1);

foreach $photo(@photo)
{
	$curl_regnewphoto = "-F _submitted=1 -F MAX_FILE_SIZE=10485760 -F uid=$uid -F photo=\@$photo -F caption=";
	$command = "curl $curl_regnewphoto -b " . $crawler->dir . "/" . $crawler->cookies . " " . URL_REG_NEW_PHOTO . " > " . $crawler->dir . "/" . FILE_REG_NEW_PHOTO;

	print "\n$command\n\n";

	system($command);
}

sub randarray {
        my @array = @_;
        my @rand = undef;
        my $seed = $#array + 1;
        my $randnum = int(rand($seed));
        $rand[$randnum] = shift(@array);
        while (1) {
                my $randnum = int(rand($seed));
                if ($rand[$randnum] eq undef) {
                        $rand[$randnum] = shift(@array);
                }
                last if ($#array == -1);
        }
        return @rand;
}
