FROM ubuntu:17.10
#FROM ubuntu:16.04

MAINTAINER FND <fndemers@gmail.com>

ENV PROJECTNAME=DROPBOX_CLIENT

ENV WORKDIRECTORY=/root

ENV SERVER_HOST=159.89.124.41

ENV SERVER_PORT=5000

RUN apt-get -y update

RUN apt install -y git curl python3 python3-pip
RUN python3 --version
RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen fr_CA.UTF-8
ENV TZ=America/Toronto
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV PYTHONIOENCODING=utf-8

# Mise à jour PIP
RUN pip3 install --upgrade pip

ENV PYTHONPATH .

# Préalable pour installer Docker
RUN apt-get -y update \
    && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    software-properties-common

# Docker repos
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update

# Installation de Docker
RUN apt-cache policy docker-ce
RUN apt-get -y install docker-ce

ENV USER_DOCKER=root
#RUN usermod -aG docker ${USER_DOCKER}

# Installation docker-compose 1.20
RUN curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Gestion Docker par Python
RUN pip3 install docker

ADD client.zip /root/

EXPOSE $SERVER_PORT

CMD python3 /root/client.zip $SERVER_HOST $SERVER_PORT