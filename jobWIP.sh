
#!/bin/bash
# open DesignGraphics to desired directory
# usage: open terminal and navigate to parent directory 
# where script lives, then type "bash .job.sh -j <######>"

if [[ $1 == "" ]]; then
    echo "you must pass an option to open the appropriate DesignGraphics directory"
    exit;
else

   while getopts 'j:' opt; do
   	echo "it's working this far"
    case $opt in
      j)  
        dest_path=`echo "$2" | cut -c1-3 | awk '{print $1"000s"}'`
        file_path="/$dest_path/"
        echo $file_path
        dest_path_2=`echo $dest_path | cut -c1-3`
        dest_path_3=`echo "$2"  | head -c 4 | tail -c 1 | awk '{print $1"00s"}'`
        dest_path_2="$dest_path_2$dest_path_3"
        end_path=`echo $file_path$dest_path_2"/$2"`
        open '/Volumes/ddc/DesignGraphics'$end_path
        echo $?
        ;;
    esac
   done
fi
