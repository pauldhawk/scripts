#!/bin/sh

####################################################################################################
#
# UNBIND FROM AD PARAMETERS
#
####################################################################################################

# CREDENTIALS FOR USER WITH PERMISSION TO UN-BIND FROM AD
username=""
password=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "username"
if [ "$4" != "" ] && [ "$username" == "" ]; then
    username=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "password"
if [ "$5" != "" ] && [ "$password" == "" ]; then
    password=$5
fi

####################################################################################################
#
# SCRIPT CONTENTS
#
####################################################################################################

if [ "$username" == "" ]; then
	echo "Error:  No username is specified.  Please specify a network username."
	exit 1
fi

if [ "$password" == "" ]; then
	echo "Error:  No password is specified.  Please specify a network password."
	exit 1
fi


echo "Unbinding the computer from Active Directory..."
/usr/sbin/dsconfigad -r -u "$username" -p "$password"


echo "Restarting Directory Services..."
#/usr/bin/killall DirectoryService
/usr/bin/killall opendirectoryd

# PAUSE BEFORE BINDING TO AD
sleep 30

####################################################################################################
#
# BIND TO AD PARAMETERS
#
####################################################################################################

# GET COMPUTER NAME

computerid=`/usr/sbin/scutil --get LocalHostName`

# STANDARD OPTIONS

domain=".com"			# fully qualified DNS name of Active Directory Domain
udn=""				# username of a privileged network user
password="@t3"				# password of a privileged network user
ou=""		# Distinguished name of container for the computer eg:OU=MAC,OU=Workstations,OU=1,OU=Toronto,OU=CA,DC=globalservs,DC=com

# ADVANCED OPTIONS

alldomains="enable"			# 'enable' or 'disable' automatic multi-domain authentication
localhome="enable"			# 'enable' or 'disable' force home directory to local drive
protocol="smb"				# 'afp' or 'smb' change how home is mounted from server
mobile="enable"			# 'enable' or 'disable' mobile account support for offline logon
mobileconfirm="disable"		# 'enable' or 'disable' warn the user that a mobile acct will be created
useuncpath="disable"			# 'enable' or 'disable' use AD SMBHome attribute to determine the home dir
user_shell="/bin/bash"		# e.g., /bin/bash or "none"
preferred="-nopreferred"	# Use the specified server for all Directory lookups and authentication
							# (e.g. "-nopreferred" or "-preferred ad.server.edu")
admingroups="domain admins,enterprise admins,US-Chicago-OU-Admins"	# These comma-separated AD groups may administer the machine (e.g. "" or "APPLE\mac admins")

####################################################################################################
#
# SCRIPT CONTENTS
#
####################################################################################################

# ACTIVATE AD PLUG-IN
defaults write /Library/Preferences/DirectoryService/DirectoryService "Active Directory" "Active"
plutil -convert xml1 /Library/Preferences/DirectoryService/DirectoryService.plist
sleep 5

# BIND TO AD
dsconfigad -f -a $computerid -domain $domain -u $udn -p "$password" -ou "$ou"

# CONFIGURE AD OPTIONS
if [ "$admingroups" = "" ]; then
	dsconfigad -nogroups
else
	dsconfigad -groups "$admingroups"
fi

dsconfigad -alldomains $alldomains -localhome $localhome -protocol $protocol \
	-mobile $mobile -mobileconfirm $mobileconfirm -useuncpath $useuncpath \
	-shell $user_shell $preferred

# RESTART DIRECTORY SERVICES
#killall DirectoryService
killall opendirectoryd

# UPDATE SEARCH PATH
if [ "$alldomains" = "enable" ]; then
	csp="/Active Directory/All Domains"
else
	csp="/Active Directory/$domain"
fi

#dscl /Search -create / SearchPolicy CSPSearchPath
#dscl /Search -append / CSPSearchPath "/Active Directory/All Domains"
#dscl /Search/Contacts -create / SearchPolicy CSPSearchPath
#dscl /Search/Contacts -append / CSPSearchPath "/Active Directory/All Domains"

# This works in a pinch if the above code does not
defaults write /Library/Preferences/DirectoryService/SearchNodeConfig "Search Node Custom Path Array" -array "/Active Directory/All Domains"
defaults write /Library/Preferences/DirectoryService/SearchNodeConfig "Search Policy" -int 3
defaults write /Library/Preferences/DirectoryService/ContactsNodeConfig "Search Node Custom Path Array" -array "/Active Directory/All Domains"
defaults write /Library/Preferences/DirectoryService/ContactsNodeConfig "Search Policy" -int 3

plutil -convert xml1 /Library/Preferences/DirectoryService/SearchNodeConfig.plist

# SELF DISTRUCT IN 3... 2... 1... if you want the script to delete itself un-comment next line
# rm $0
