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
	$wget_editaccount
);

use constant URL_EDITACCOUNT => 'http://www.friendster.com/editaccount.php';
use constant FILE_EDITACCOUNT => 'file_editaccount.htm';
use constant REGEX_INPUT_UID => '<input type\=\"hidden\" name\=\"uid\" value\=\"(\d+)\">';

$email = shift(@ARGV);
$password = shift(@ARGV);
$dir = shift(@ARGV) || rand();
#@photo = @ARGV;

#@photo = &randarray(@photo);

$crawler = FriendsterMobileProfileBrowser->new(
	email => $email,
	password => $password,
	dir => "$email/" . $dir,
);

$wget_editaccount = "--post-data \"email=$email&_submitted=1&languagepref=en-US&enablehoroscopes=1&Submit=Save&ShowMyTracker=2&ValidateFanRequest=1&DisplayLastname=1&ViewProfilesAnonymously=0&profiledepth=0&messagedepth=0&enableprofileskins=1&showbirthday=1&Submit=Save&PublicCommentAcceptComment=2&PublicCommentAutoApprove=2&Submit=Save&PhotoCommentsAllow=1&PhotoRatingsAllow=1&PhotoGrabbingAllow=1&Submit=Save&FriendAlerts=3&EntityAlerts=3&BookmarkAlerts=3&GroupAlerts=3&ClassmateAlerts=3&weeklyupdates=y&messageEmailsFrom=0&ReceiveAppInvitesOptOut=0&ReceiveRecommendations=1&ReceiveBulletinNotifications=1&notifications=y&ReceiveFriendUpdatesOptIn=1&ShoutoutCommentNotify=1&Submit=Save\"";

$crawler->browse(URL_EDITACCOUNT, FILE_EDITACCOUNT, $wget_editaccount);

=begin
$uid = $crawler->{crawler}->find(FILE_EDITACCOUNT, REGEX_INPUT_UID, 1);

foreach $photo(@photo)
{
	$curl_regnewphoto = "-F _submitted=1 -F MAX_FILE_SIZE=10485760 -F uid=$uid -F photo=\@$photo -F caption=";
	$command = "curl $curl_regnewphoto -b " . $crawler->dir . "/" . $crawler->cookies . " " . URL_EDITACCOUNT . " > " . $crawler->dir . "/" . FILE_EDITACCOUNT;

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
=cut

