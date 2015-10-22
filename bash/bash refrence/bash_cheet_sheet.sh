loops

for
      for p in $(ls) do
            echo p
      done


if
      if [ 1 -eq 2 ] then
      	echo true
      else
            echo false
      fi

unzip file
   tar -zxf Canon.zip
download file
   curl -O "10.162.80.41:8080/Canon.zip"


printer install
      lpadmin -p name -L "name" -E -v lpd://10.162.80.96 -P /to/driver

install program
   /usr/sbin/installer -pkg /installer/path -target /

open app
   open appname

plist changes
   # Allow Print Operator Access
   security authorizationdb write system.print.operator allow
   defaults write /Library/Preferences/DirectoryService/DirectoryService "Active Directory" "Active"
   plutil -convert xml1 /Library/Preferences/DirectoryService/SearchNodeConfig.plist

kill app
   killall opendirectoryd
kill process
    kill (process_id)
list port open
   lsof -i:2540


the lsof will display the process number using the port. get that and
   kill (process_id) // something like kill 4068
show hidden files
   alias show="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"

pipe to text file
   > [file]	Push output to file, keep in mind it will get overwritten
   >> [file]	Append output to existing file
   <	Tell command to read content from a fi

file name based on date
   name=$(date '+%y-%m-%d')
   tar -zcvf "$name.tar.gz" code
   or even in one line:

   tar -zcvf "$(date '+%y-%m-%d').tar.gz" code
   Drop -z flag if you want .tar instead of .tar.gz.

   $() is used for command substitution.
date format
%FORMAT String	Description
%%	a literal %
%a	locale's abbreviated weekday name (e.g., Sun)
%A	locale's full weekday name (e.g., Sunday)
%b	locale's abbreviated month name (e.g., Jan)
%B	locale's full month name (e.g., January)
%c	locale's date and time (e.g., Thu Mar 3 23:05:25 2005)
%C	century; like %Y, except omit last two digits (e.g., 21)
%d	day of month (e.g, 01)
%D	date; same as %m/%d/%y
%e	day of month, space padded; same as %_d
%F	full date; same as %Y-%m-%d
%g	last two digits of year of ISO week number (see %G)
%G	year of ISO week number (see %V); normally useful only with %V
%h	same as %b
%H	hour (00..23)
%I	hour (01..12)
%j	day of year (001..366)
%k	hour ( 0..23)
%l	hour ( 1..12)
%m	month (01..12)
%M	minute (00..59)
%n	a newline
%N	nanoseconds (000000000..999999999)
%p	locale's equivalent of either AM or PM; blank if not known
%P	like %p, but lower case
%r	locale's 12-hour clock time (e.g., 11:11:04 PM)
%R	24-hour hour and minute; same as %H:%M
%s	seconds since 1970-01-01 00:00:00 UTC
%S	second (00..60)
%t	a tab
%T	time; same as %H:%M:%S
%u	day of week (1..7); 1 is Monday
%U	week number of year, with Sunday as first day of week (00..53)
%V	ISO week number, with Monday as first day of week (01..53)
%w	day of week (0..6); 0 is Sunday
%W	week number of year, with Monday as first day of week (00..53)
%x	locale's date representation (e.g., 12/31/99)
%X	locale's time representation (e.g., 23:13:48)
%y	last two digits of year (00..99)
%Y	year
%z	+hhmm numeric timezone (e.g., -0400)
%:z	+hh:mm numeric timezone (e.g., -04:00)
%::z	+hh:mm:ss numeric time zone (e.g., -04:00:00)
%:::z	numeric time zone with : to necessary precision (e.g., -04, +05:30)
%Z	alphabetic time zone abbreviation (e.g., EDT)

open app mac
   -a application
           Specifies the application to use for opening the file

       -b bundle_indentifier
           Specifies the bundle identifier for the application to use when opening the file

       -e  Causes the file to be opened with /Applications/TextEdit

       -t  Causes the file to be opened with the default text editor, as determined via LaunchServices

       -f  Reads input from standard input and opens the results in the default text editor.  End input by
           sending EOF character (type Control-D).  Also useful for piping output to open and having it open
           in the default text editor.

       -F  Opens the application "fresh," that is, without restoring windows. Saved persistent state is lost,
           except for Untitled documents.

       -W  Causes open to wait until the applications it opens (or that were already open) have exited.  Use
           with the -n flag to allow open to function as an appropriate app for the $EDITOR environment vari-able. variable.
           able.

       -R  Reveals the file(s) in the Finder instead of opening them.

       -n  Open a new instance of the application(s) even if one is already running.

       -g  Do not bring the application to the foreground.

       -h  Searches header locations for a header whose name matches the given string and then opens it.  Pass
           a full header name (such as NSView.h) for increased performance.

       --args
           All remaining arguments are passed to the opened application in the argv parameter to main().
           These arguments are not opened or interpreted by the open tool.

  EXAMPLES
       "open '/Volumes/Macintosh HD/foo.txt'" opens the document in the default application for its type (as
       determined by LaunchServices).
