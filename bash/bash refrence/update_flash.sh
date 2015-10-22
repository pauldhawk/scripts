#!/bin/sh
# tar -zxf flash.zip to zip
if [ -d /tempinstaller ]
then
	echo ""
else
	mkdir /tempinstaller
fi

cd /tempinstaller

curl -O "10.162.80.41:8080/Flash.zip"

tar -zxf Flash.zip

for program in /tempinstaller/Flash/*
	do 
		/usr/sbin/installer -pkg "$program" -target / 
	done

rm -fr /tempinstaller/