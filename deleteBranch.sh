
#!/bin/bash
# Usage: 
# Create a directory called shell scripts at the same level as ddins. 
# Place this file in a directory adjacent to <my-git-directory> in need of cleaning.
# Type the following text between the <> into terminal. <. deleteBranch.sh>
# script changes directory into git directory, 
# places all git branch names into a newly-generated file,
# reads that file line-by-line, and 
# deletes remotely, then locally, all branches which do not contain the phrases 'master' or 'dev'
# deletes the file with branch names and returns cursor to shell-scripts directory. 

cd ../<my-git-directory>
touch gitOut.txt
git branch > gitOut.txt
file=gitOut.txt

while read line; do
  if  echo "$line" | grep -q 'dev'; then
  continue
  elif   echo "$line" | grep -q 'master'; then
  continue
  fi

  if  [[ $1 = '-dry-run' ]]; then  
    echo "$line" "would be deleted remotely and locally in a real run"
    continue
  else

    echo "$line" "will be deleted remotely and locally"
    git push origin --delete "$line"
    git branch -D "$line"

  fi

done < "$file"

rm gitOut.txt

cd ../shell-scripts


