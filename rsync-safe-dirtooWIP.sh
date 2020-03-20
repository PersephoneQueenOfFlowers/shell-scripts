
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
  function make_path () {
   remote_path="webpush@rc-lx164"
   full_path="" 
   dest_path=""
   dest_path_dir="$2"
  }
  function branch_check () {
    git branch 
  }
  function dir_change () {
    echo "dirchange called"
    cd ../"$1""$2"
    pwd
  }
  

   while getopts 'dps:' opt; do
    case $opt in
      s)  
        echo "$1$2"
        if [ $2 = "ddins" ]; then
          dir_change "ddins"
        elif [ $2 = "feds" ]; then
          dir_change "feds"
        elif [ $2 = "trdp" ]; then
          dir_change "trdp" 
        else
          cd ../ddins
          echo "default ddins selected"
        fi
        ;;
      d)
      echo "pubdev picked"
      if [ $2 = "ddins" ]; then
        make_path "" "htdocs"
      else
        make_path "pubdev." "$2"
      fi  
      echo "dest path dir is: ""$dest_path_dir"
      dest_path="0.ut.dentegra.lab:/opt/jail/webpush/"
      full_path="$remote_path""$dest_path""$dest_path_dir"
      echo "full_path is: ""$full_path"
 
        if branch_check | grep -q '* develop'; then
          if git status | grep -i 'nothing to commit, working tree clean'; then
            rsync --dry-run -PvczrlpgoD "$(pwd -P)" "$full_path" --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'
          else
            echo "you must add and committ any unstaged and/or uncommitted files. Ideally, there should not ever be unstaged or uncommitted files on develop"
          fi
        else
          echo "you must have added and committed files to your feature or test branch, checked out develop, pulled latest, and merged your branch before performing rsync with pubdev"
        fi
         ;;
      p)
      echo "pub picked"
      make_path "$2"
      echo "dest path dir is: ""$dest_path_dir"
      dest_path="1.ut.dentegra.lab:/opt/jail/webpush/"
      full_path="$remote_path""$dest_path""$dest_path_dir"
      echo "full_path is: ""$full_path"
      #   if branch_check | grep -q '* master'; then
      #     if git status | grep -i 'nothing to commit, working tree clean'; then
      #       rsync -PvczrlpgoD "$(pwd -P)" webpush@rc-lx1641.ut.dentegra.lab:/opt/jail/webpush/htdocs/ --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'
      #     fi
      #   else
      #     echo "you must have approval on all changes from feature or test branch, merged them into master before performing rsync with pub."
      #   fi
      #   ;;
      # \?)
      #   echo "Invalid option: -$OPTARG"
         ;;
    esac
  done
fi
