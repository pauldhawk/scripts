#!/bin/bash

if [ -d /tempinstaller ]
	then
		echo ""
	else
		mkdir /tempinstaller
fi

cd /tempinstaller

# download and unzip java.zip

curl -O "10.162.80.41:8080/Java.zip"
tar -zxf Java.zip

# install it
for program in /tempinstaller/Java/*  
	do 
		/usr/sbin/installer -pkg "$program" -target / 
	done
	
curl -O "10.162.80.41:8080/Flash.zip"

tar -zxf Flash.zip

for program in /tempinstaller/Flash/*
	do 
		/usr/sbin/installer -pkg "$program" -target / 
	done
# clean up files
rm -fr /tempinstaller/
