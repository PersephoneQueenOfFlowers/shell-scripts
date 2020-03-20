#!/bin/bash
# On a cronjob, once per day, at midnight,
# First, find files with the extensions (.wmv, .mov, .web4, or .mp4), and put their names in a log.

find ./ -type f \( -iname \*.wmv -o -iname \*.mov  -o -iname \*.web4  -o -iname \*.mp4 \) > videolog.txt

# next read from that log each file, and check the age of file. If it's old enough, send an email.
# TODO create log of old files, and load each file name into that log after emailing
# , then compare to be sure it's not in there before sending email. :-)  

function expiration_email() {

	echo "$1" + "$2" + "$3"

	SUBJECT="Automated Expiration Alert"
	TO="SSchoenfeld@delta.org,sethschoenfeld@gmail.com"
	MESSAGE="/tmp/message.txt"
  replyto="sethschoenfeld@gmail.com"   

	echo "${1} is within ${2} days of expiration." >> $MESSAGE
	echo "Time: `date`" >> $MESSAGE

	/usr/bin/mail -s "$SUBJECT" "$TO" -- -r "sethschoenfeld@gmail.com"  < $MESSAGE

	rm $MESSAGE
}

IFS='
'
set -f

while read line; do
  
  output="$(date -r $line +%s)"
  now="$(date +%s)"
  ageoffile=`expr "${now}" - "${output}"`

  if [ "${ageoffile}" -gt 91656000 ]; then
		grep -qxF 'include' "${line}" ./30dayExpire.txt || expiration_email "${line}" 30 "${now}" 
		echo "${line}" >> ./30dayExpire.txt	

  elif [ "${ageoffile}" -gt 88424000 ]; then
  	grep -qxF 'include' "${line}" ./60dayExpire.txt || expiration_email "${line}" 60 "${now}"
  	echo "${line}" >> ./60dayExpire.txt
  fi

done < ./videolog.txt

# remove videolog.txt file. 
rm ./videolog.txt

# some seconds calculations broken down
# 94,608,000 = 3 years
# - 2,952,000 = 30 days out or 91,656,000 sec
#  - 5,184,000 sec = 60 days out or 88,424,000 sec

#####################

# cron job command 
# 00 00 * * * /home/177607/users/.home/domains/video.deltadentalins.com/html/videos




