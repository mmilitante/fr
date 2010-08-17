#!/bin/bash

# mysql settings
MYSQL_HOSTNAME="localhost"
MYSQL_USERNAME="root"
MYSQL_PASSWORD="-pmike6629"		# if protected, place here "-p<yourpassword>"
MYSQL_DATABASE="fr"

# mysql strings
MYSQL_BINARY="mysql"
MYSQL_STRING="$MYSQL_BINARY -h$MYSQL_HOSTNAME -u$MYSQL_USERNAME $MYSQL_PASSWORD $MYSQL_DATABASE"

# arguments
instance=$1; shift

while [ 0 ]
do
	result=`$MYSQL_STRING -N -e "select email from bots where type='crawler' and status = '' order by rand();"`

	for email in $result
	{
		password=`$MYSQL_STRING -N -e "select password from bots where email = '$email';"`
		uid=`$MYSQL_STRING -N -e "select cast((rand() * 100000000) + rand() * 10000000 + rand() * 1000000 as unsigned integer);"`
		bash profile-browse.sh $email $password $instance $uid
	}
done

