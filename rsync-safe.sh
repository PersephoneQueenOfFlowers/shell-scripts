
#!/bin/bash
# run rsync with correct params and from correct git branch with 
# status nothing to commit; ie - all files added and committed. 
# rsync-safe -[param] 
# params [-d] = pubdev; [-p] = pub; if rsync-safe is run with no params, it will not run. 
# This way, rsync is only run on purpose from the correct branch to the correct remote.  
# Place rsync-safe.sh into a directory which resides at the same level
# as ddins; eg ~ /Users/[usernumber]/Documents/projects/shell-scripts/rsync-safe.sh 
# where ~        /Users/[usernumber]/Documents/projects/ddins

if [[ $1 == "" ]]; then
    echo "you must pass an option -d for pubdev or -p for pub to rsync-safe
otherwise it will not know what remote repository you want to sync with."
    exit;
else
  cd ../ddins

  function branch_check () {
    git branch 
  }

   while getopts 'dp:' opt; do
    case $opt in
      d)
        if branch_check | grep -q '* develop'; then
          if git status | grep -i 'nothing to commit, working tree clean'; then
            rsync -PvczrlpgoD "$(pwd -P)" webpush@rc-lx2667.ut.dentegra.lab:/opt/jail/webpush/htdocs/ --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'
          else
            echo "you must add and committ any unstaged and/or uncommitted files. Ideally, there should not ever be unstaged or uncommitted files on develop"
          fi
        else
          echo "you must have added and committed files to your feature or test branch, checked out develop, pulled latest, and merged your branch before performing rsync with pubdev"
        fi
        ;;
      p)
        if branch_check | grep -q '* master'; then
          if git status | grep -i 'nothing to commit, working tree clean'; then
            rsync -PvczrlpgoD "$(pwd -P)" webpush@rc-lx1641.ut.dentegra.lab:/opt/jail/webpush/htdocs/ --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'
          fi
        else
          echo "you must have approval on all changes from feature or test branch, merged them into master before performing rsync with pub."
        fi
        ;;
      \?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done
fi
