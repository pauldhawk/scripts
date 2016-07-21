#!/bin/bash

group=$(id -g)
user=$(id -u)
folder=$1
ok=true

echo
# check for group not null
if [[ -z $group ]]
then
    ok=false
    echo "ERROR: unable to find a group number for current user"
fi
# check for user not null
if [[ -z $user ]]
then
    ok=false
    echo "ERROR: unable to find a user number for current user"
fi
# check folder not null
if [[ -z "$folder" ]]
then
    ok=false
    echo "ERROR: folder to change ownership was not past please add it at the end of the command"
# check for valid folder
elif  [[ ! -d "$folder" ]]
then
    ok=false
    echo "ERROR: $folder is not a valid path"
    echo
fi

# run command if not errors
if $ok
then
    echo changeing folder permissions
    echo command being exucted: sudo chown -R $user:$group $folder
    sudo chown -R $user:$group $folder
    echo
    echo DONE!
fi
