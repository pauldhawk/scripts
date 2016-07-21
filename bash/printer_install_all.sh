#!/bin/sh

##### remove old printers
for p in $(ls /private/etc/cups/ppd | grep -i "")
	do
		/usr/sbin/lpadmin -x "${p%\.ppd}"
	done


#### create temp folder
if [ -d /tempinstaller ]
	then
		echo ""
	else
		mkdir /tempinstaller
fi

cd /tempinstaller

####### download and unzip file
curl -O "10.0.8.41:8080/Canon.zip"

tar -zxf Canon.zip

###### install driver
/usr/sbin/installer -pkg /tempinstaller/Canon/Canon\ Drivers\ Mac.pkg -target /

###### install printers
lpadmin -p printer_name -L "Printer Name" -E -v lpd://10.1.8.96 -P /path/to/triber

#### install prefs
for pref in /tempinstaller/Canon/MacPPDColor/*
	do
		/usr/sbin/installer -pkg "$pref" -target /
	done

##install settings to local lib/prefs folder
for luser in /Users/*
	do
	cp -f /tempinstaller/Canon/printer_settings/* $luser/Library/Preferences
done

#### clean up tempfolder
rm -fr /tempinstaller/
