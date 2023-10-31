#Support bundle generation button on the UI puts zips inside zips

dirname="$(date +"%d-%m-%Y")"

mkdir $dirname

cp $1 $dirname

cd $dirname

a=4
while [ $a -gt 0 ];
do
find . -name "*.zip" | while read filename; do unzip -o -d "`dirname "$filename"`" "$filename"; echo "$filename" ;rm "$filename"; done;
((a--))
done

#Some people are putting gz files in zips
find . -name "*.gz" -type f -print0 | xargs -0 gunzip

mkdir -p extracted-logs
find . -name "*request*log" -type f -exec cp {} extracted-logs \;

cd extracted-logs

rm *request-out*log

#I always put all my projects into ~/workspace (developer cleanliness since a decade) - you probably need to change this line 
python3 ~/workspace/requesttime-master/requestTime-3.py * -x
