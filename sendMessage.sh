#!/bin/bash
SUBJECT="Automated Security Alert"
TO="SSchoenfeld@delta.org"
MESSAGE="/tmp/message.txt"

echo "it's old!" >> $MESSAGE
echo "Time: `date`" >> $MESSAGE

/usr/bin/mail -s "$SUBJECT" "$TO" < $MESSAGE

rm $MESSAGE