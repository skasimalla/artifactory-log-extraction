version=1.5
echo $version
DOCKER_BASE=skasimalla

docker build -t $DOCKER_BASE/generate_report:$version .

#docker tag skasimalla/generate_report:$version solengcustomersupport.jfrog.io/docker-local/generate_report:$version
git tag $version -f
git push origin $version -f

