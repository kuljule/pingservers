#!/bin/bash

# This script pings servers listed in serverlist.txt and if there is no response 4 times in a row, it sends an email to your email address.

cd /home/mysqlv10																			# make sure in home directory. This is needed if running in cron
date +"%T" > pingservers-start.txt															# send start time stamp to pingservers-start.txt
rm pingservers.txt																			# remove old pingservers.txt
cat /home/mysqlv10/serverlist.txt | while read output										# open serverlist.txt and while reading each line, do the following:
do
	ping -c 4 "$output" > /dev/null								# ping each line 4 times
	if [ $? -ne 0 ]; then										# if you don't get a ping all 4 times then
	echo "node $output is down"									# print "node output is down"
	fi
done >> pingservers.txt																		# send results to pingservers.txt

if [ `ls -l pingservers.txt | awk '{print $5}'` -eq 0 ]										# if pingservers.txt has no data or 5th column in ls -l is equal to 0
	then
	echo "pingservers.txt is empty."							# then print "pingservers.txt is empty"
	exit 1														# and exit the script
fi

mail -s "Some Hosts are Down!" julianrseidel@gmail.com < pingservers.txt		# email results of pings in pingservers.txt to your email with the subject "Some Hosts are Down!"
date +"%T" > pingservers-end.txt															# send end time stamp to pingservers-end.txt