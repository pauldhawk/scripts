#!/bin/sh

#location/name of plist version file
flash_ver_cli_folder="/path/to/install"
flash_ver_cli="/path/to/install"
flash_installer_cli="/path/to/install"

flash_ver_srv="/path/to/install/Info.plist"
flash_ver_srv_folder="/path/to/install/Flash/version/"
flash_installer_srv="/Volumes/installer"

# create flash folder
if [ ! -d $flash_ver_cli ]; then
	mkdir -p $flash_ver_cli_folder
	mkdir -p $flash_installer_cli
fi
ditto "$flash_ver_srv_folder" "$flash_ver_cli_folder"


# get installed versin and verion on the server
	client_version=`/usr/bin/defaults read /Library/Internet\ Plug-Ins/Flash\ Player.plugin/Contents/Info.plist CFBundleVersion`
	server_version=`/usr/bin/defaults read $flash_ver_cli CFBundleVersion`
# log it
	echo "client_version: $client_version server_version: $server_version" #>> ${logfile}

# if the versions are difrent install the new one
	if [ "$client_version" == "$server_version" ] ; then
		echo "Flash is up to date; " #>> ${logfile} ;
	else echo "Flash: Downloading Installer" #>> ${logfile};
		ditto $flash_installer_srv $flash_installer_cli

		# run whatever file is in the flash dir
		for program in $flash_installer_cli/* ; do /usr/sbin/installer -pkg "$program" -target / ; done
		#check to see if update wokred
		client_version=`/usr/bin/defaults read /Library/Internet\ Plug-Ins/Flash\ Player.plugin/Contents/Info.plist CFBundleVersion`
		if [ "$client_version" == "$server_version" ]; then
			echo "update sususfull"
		else
			echo "booooooo"
		fi
	fi
