find . -name "*.zip" | while read filename; do unzip -o -d "`dirname "$filename"`" "$filename"; done;
cd artifactory
#For whatever reason some people are putting zips inside zips
find . -name "*.zip" | while read filename; do unzip -o -d "`dirname "$filename"`" "$filename"; done;

#Some people are putting gz files in zips
find . -name "*.gz" -type f -print0 | xargs -0 gunzip

mkdir -p extracted-logs
find . -name "*request*log" -type f -exec cp {} extracted-logs \;

cd extracted-logs

rm *request-out*log
