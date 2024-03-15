#This script was designed and tested on Mac, ig might work on Windows, but it hasn't been tested by me. 
#First parameter should be the name of the zip file
#Support bundle generation button on the UI puts zips inside zips
dirname=$1"$(date +"%Y%m%d")"

mkdir $dirname
cp $1 $dirname
cp savecopy $dirname

cd $dirname

a=4
while [ $a -gt 0 ];
do
find . -name "*.zip" | while read filename; do unzip -o -d "`dirname "$filename"`" "$filename"; echo "$filename" ;rm "$filename"; done;
((a--))
done

#Support bundle puts gz inside zip
find . -name "*.gz" -type f -print0 | xargs -0 gunzip

mkdir -p extracted-logs
chmod +x saveCopy
find . -name "artifactory-request*log" -type f -exec ./saveCopy {} extracted-logs \;

rm extracted-logs/*request-out*log

PWD=`pwd`
echo $PWD

cd -
#I always put all my projects into ~/workspace (developer cleanliness since a decade) - you probably need to change this line 
python3 ./requesttime/requestTime-3.py $dirname/extracted-logs/* -x
