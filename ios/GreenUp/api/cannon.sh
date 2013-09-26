#!/bin/sh
echo "Kill the PID below to stop script (kill 12)"
echo $$
echo "Cannon.sh creates 1000 curl processes against the passed in url\n"

if [ "$#" -ne 1 ]
then
 	echo "You must supply a url to send GET requests to."
	echo "Usage: "
	echo "./cannon.sh localhost:30002/api"
	echo "./cannon.sh localhost:30002/api/comments"
	exit 1
fi

for i in `seq 1 1000` ; do
	(curl -s -o /dev/null "$1" &) 
done

