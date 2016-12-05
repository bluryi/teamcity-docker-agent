# Copyright 2016 Fetch Robotics, Inc.
# Author(s): Xu Han

FROM teamcity-minimal-agent:latest
# See teamcity docker agent instructions on Github:
# https://github.com/JetBrains/teamcity-docker-agent

MAINTAINER Xu Han <xhan@fetchrobotics.com>

LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"

RUN apt-get update && \
    apt-get install -y software-properties-common && add-apt-repository ppa:openjdk-r/ppa && apt-get update && \
    apt-get install -y git mercurial openjdk-8-jdk apt-transport-https ca-certificates && \
    \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" > /etc/apt/sources.list.d/docker.list && \
    \
    apt-cache policy docker-engine && \
    apt-get update && \
    apt-get install -y docker-engine=1.10.3-0~wily && \
    \
    apt-get clean all && \
    \
    usermod -aG docker buildagent


# Install Node && test platform
RUN \
    curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs wget && \
    npm install jasmine-reporters && \
    npm install -g protractor && \
    webdriver-manager update

# Install Chrome.
RUN \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/* &&\
    rm /etc/apt/sources.list.d/google.list

# Install DB
RUN \
    apt-get update && apt-get install -y postgresql-9.4 postgresql-contrib-9.4 postgresql-server-dev-9.4

# Other packages:
RUN \
    apt-get install -y xvfb sudo

COPY xvfb /etc/init.d/

