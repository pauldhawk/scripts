linkdir=/Users/phawk/Dropbox/school/CSC_435_Systems/assignments/Mimer/util/files_to_link/

eclipsroot=/Users/phawk/Dropbox/development/eclipse/test/
eclipsbin=/Users/phawk/Dropbox/development/eclipse/test/bin/
systmesfolder=/Users/phawk/Dropbox/school/CSC_435_Systems/assignments/Mimer/program/

cd $linkdir

for p in $(ls)
do
   echo $p
   if [ -a $eclipsbin$p ]
   then
     echo exisits
   else
     ln -s $linkdir$p $eclipsbin$p
   fi

   if [ -a $eclipsroot$p ]
   then
     echo exisits
   else
      ln -s $linkdir$p $eclipsroot$p
   fi

   if [ -a $systmesfolder$p ]
   then
     echo exisits
   else
      ln -s $linkdir$p $systmesfolder$p
   fi
done
