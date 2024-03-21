FROM python:3.12-slim
MAINTAINER Sam Kasimalla

RUN mkdir -p /app
COPY ./ /app/

RUN apt-get -y update; apt-get -y install curl jq zip
RUN pip install -r /app/requests-report/requirements.txt

CMD ["chmod", "+x", "/app/run-inside-docker.sh"]

ENTRYPOINT ["/app/run-inside-docker.sh"]