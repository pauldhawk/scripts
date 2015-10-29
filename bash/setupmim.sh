pro=/Users/phawk/Dropbox/school/CSC_435_Systems/assignments/Mimer/program
ecl=/Users/phawk/Dropbox/development/eclipse/test/src

cd $pro

rm -r ./*

ditto $ecl $pro
sh softLinks.sh
sh ./compile_java.sh
