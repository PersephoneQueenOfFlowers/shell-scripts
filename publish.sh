publish() {
    # TODO:
    # - setup demo and prod publishing

    ##### begin config
    DDINS_ROOT="$HOME/Web/ddins/"       # local path to your ddins repo
    SSH_DEV="ddins-dev"                 # ip/ssh alias that you use to ssh into dev(pubdev)
    SSH_STAGING="ddins-stg"             # ip/ssh alias that you use to ssh into staging(pub)
    ##### end config

    BRANCH=""
    COMMAND=""

    case $1 in
        dev|pubdev)     BRANCH="dev"
                        ENVIRO=$SSH_DEV ;;

        staging|pub)    BRANCH="master"
                        ENVIRO=$SSH_STAGING ;;

        help)           printf "about:\tthis command publishes the ddins repository to various environments\nsyntax:\tpublish <demo|dev|staging|prod> <test>\nconfig:\tDDINS_ROOT and ENVIRO variables will need to be configured in your bash profile\n" ;;

        *)              printf "syntax: publish <demo|dev|staging|prod> <test>\n" ;;
    esac

    case $2 in
        test)           echo "(test run!)"
# trying flags that match publish script ('avz')
        #               COMMAND="rsync --dry-run -PvczrlpgoD $DDINS_ROOT $ENVIRO:/opt/jail/webpush/htdocs/ --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'" ;;
        #*)             COMMAND="rsync -PvczrlpgoD $DDINS_ROOT $ENVIRO:/opt/jail/webpush/htdocs/ --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'" ;;
                        COMMAND="rsync --dry-run -avz $DDINS_ROOT $ENVIRO:/opt/jail/webpush/htdocs/ --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'" ;;
        *)              COMMAND="rsync -avz $DDINS_ROOT $ENVIRO:/opt/jail/webpush/htdocs/ --exclude '.git' --exclude '.idea' --exclude '.DS_Store' --exclude 'node_modules'" ;;
    esac

    if [ -z "$BRANCH" ]; then
       return
    else
        # needed to make this foolproof... make sure we are in the right directory and pushing the latest repo version
        cd $DDINS_ROOT
        git checkout $BRANCH
        git pull # make sure we are up to date before syncing, this should 99.9999999% of the time be true without needing to pull

        # determine if there are git conflicts before proceeding
        CONFLICTS=$(git ls-files -u | wc -l)

        if [ "$CONFLICTS" -gt 0 ] ; then
            echo "error: git  merge conflict, aborting"
            git merge --abort
            return
        else
                #printf "$COMMAND" # for debugging which command is actually issued in the end
                eval "$COMMAND"
        fi
    fi
}