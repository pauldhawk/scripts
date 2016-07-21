#!/bin/sh

## get count of new printers
count=`ls /private/etc/cups/ppd | grep -i -E -c '((new_printer1)|(new_printer3)|(new_printer3))+'`
old_printers=`ls /private/etc/cups/ppd | grep -i -E -c '((old_printer1)|(old_printer3)|(old_printer3))+'`

# only run if the printers are not installed
if [ $count -gt 0 ]
    then
        # remove old printers
        for p in $(ls /private/etc/cups/ppd | grep -i -E $old_printers)
        	do
        		/usr/sbin/lpadmin -x "${p%\.ppd}"
        	done

        # create temp folder
        if [ -d /tempinstaller ]
        	then
        		echo ""
        	else
        		mkdir /tempinstaller
        fi

        cd /tempinstaller

        # download and unzip file
        curl -O "10.0.8.41:8080/Canon.zip"

        tar -zxf Canon.zip

        # install driver
        /usr/sbin/installer -pkg /tempinstaller/Canon/Canon\ Drivers\ Mac.pkg -target /

        # install printers
        lpadmin -p printer1 -L "Printer 1" -E -v lpd://10.1.8.96 -P /path/to/driber
        lpadmin -p printer2 -L "Printer 2" -E -v lpd://10.1.8.97 -P /path/to/driber

        # install prefs
        for pref in /tempinstaller/Canon/MacPPDColor/*
        	do
        		/usr/sbin/installer -pkg "$pref" -target /
        	done

        # install settings to local lib/prefs folder
        for luser in /Users/*
        	do
        	cp -f /tempinstaller/Canon/printer_settings/* $luser/Library/Preferences
        done

        #### clean up tempfolder
        rm -fr /tempinstaller/

fi
