#!/bin/bash

# url constants
URL_BASE="http://www.friendster.com"
URL_LOGIN="$URL_BASE/login.php"
URL_PROFILE="http://profiles.friendster.com"

# mysql settings
MYSQL_HOSTNAME="localhost"
MYSQL_USERNAME="root"
MYSQL_PASSWORD="-pmike6629"		# if protected, place here "-p<yourpassword>"
MYSQL_DATABASE="fr"

# mysql strings
MYSQL_BINARY="mysql"
MYSQL_STRING="$MYSQL_BINARY -h$MYSQL_HOSTNAME -u$MYSQL_USERNAME $MYSQL_PASSWORD $MYSQL_DATABASE"

# retry settings
MAX_ERRORS=3
ERRORS=0

# the arguments: profile-browse.sh <username> <password> <instance> [<uid1> <uid2> ... <uidn>] 
username=$1; shift
password=$1; shift
instance=$1; shift
uids=$@; shift

dir="$username/$instance"

if [ ! -d "$dir" ]
then
	mkdir -p "$dir"
fi

curl_login="-F _submitted=1 -F next=/ -F tzoffset=-480 -F email=$username -F password=$password -F rememberme=on"
cookies="$dir/$username.txt"

function login
{
	result=`curl $URL_LOGIN $curl_login -b $cookies -c $cookies`

	errorbox=`echo $result | grep -oP '<div class="boxcontent">(.+?)</div>'`

	status=`echo ${errorbox#<*>}`
	status=`echo ${status%<*>}`

	if [ "$status" ]
		then
		$MYSQL_STRING -e "insert into bots (email, password, status) values ('$username', '$password', '$status') on duplicate key update status = '$status';"
	fi	
}

function browse
{
	uid=$1
	curl --head -b $cookies -c $cookies $URL_PROFILE/$uid
}

function profile-browse
{
	uid=$1

	if [ ! -f "$cookies" ]
		then
		login
		profile-browse $uid
	else
		friendster_auth_v2=`cat $cookies | grep friendster_auth_v2`

		if [ "$friendster_auth_v2" ]
		then
			browse $uid
		else
			let ERRORS++

			if [ "$ERRORS" -lt "$MAX_ERRORS" ]
				then
				login
				profile-browse $uid
			fi
		fi
	fi
}

for uid in $uids
{
	profile-browse $uid

	if [ "$ERRORS" -eq "0" ]
		then
		#$MYSQL_STRING -e "insert into crawled (uid, browsed) values ('$uid', now()) on duplicate key update browsed = now();"
		$MYSQL_STRING -e "insert ignore into crawled (uid, browsed) values ('$uid', now());"
	fi	

	ERRORS=0
}


