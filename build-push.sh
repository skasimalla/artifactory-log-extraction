version=1.5
echo $version

#docker login -u ${USER} -p ${TOKEN}  solengcustomersupport.jfrog.io
#DOCKER_BASE=solengcustomersupport.jfrog.io/docker-local

DOCKER_BASE=skasimalla

#docker build -t $DOCKER_BASE/generate_report:$version .
docker build -t $DOCKER_BASE/generate_report_linux:$version --platform linux/amd64 .

#docker tag skasimalla/generate_report:$version solengcustomersupport.jfrog.io/docker-local/generate_report:$version
git tag $version
git push origin $version

#docker push $DOCKER_BASE/generate_report:$version
docker push $DOCKER_BASE/generate_report_linux:$version