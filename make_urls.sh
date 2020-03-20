#!/bin/bash
#i have the strings from the corresponding files on same lines cut into separate vars,
# just need to find the first line in files and replace it with the second line.

rm -- urls.txt lousyUrls.txt

touch urls.txt
touch lousyUrls.txt

#file=urls.txt

for i in {1..100}
do

  echo "https://www.awesomesite.com/sub/sub/sub/sub/"$RANDOM >> lousyUrls.txt
  echo "https://www.awesomesite.com/sub/sub/sub/sub/"$RANDOM >> urls.txt
  
done

while read line; do
  

# find the following url...
bad= echo $line | cut -d ',' -f1 

#replace with the following url...
good= echo $line | cut -d ',' -f2 


# find ../feds/htdocs/fedvip/ \( ! -regex '.*/\..*' \) -type f | xargs sed -i 's/{$bad}/{$good}/g'

#find /Users/ca62219/Documents/projects/feds/htdocs/fedvip/dentists \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/{$bad}/{$good}/g'
#grep -r "$bad" -l | tr '\n' ' ' | xargs sed -i 's/{$bad}/{$good}/g'


 #  mails=$(echo $IN | tr ";" "\n")

 #  for addr in $mails
 #    do
	#     echo "> [$addr]"
	# done
  #read this line and do a global search for it. 
  #replace those characters with the characters from the corresponding line 
  #from the urls.txt file

#  find . -type f | xargs sed -i  's/a.example.com/b.example.com/g'

done < <(paste -d, lousyUrls.txt urls.txt)

