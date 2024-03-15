FROM python:3.12-slim
MAINTAINER Sam Kasimalla

RUN mkdir -p /app
COPY ./ /app/
COPY ./request-report/ /app/

RUN apt-get -y update; apt-get -y install curl jq
RUN pip install -r /app/requirements.txt

CMD ["chmod", "+x", "/app/run-inside-docker.sh"]

ENTRYPOINT ["/app/run-inside-docker.sh"]