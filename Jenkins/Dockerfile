FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
    apt-get install -y awscli
USER root
RUN apt-get update -qq && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update -qq && apt-get -y install docker-ce
RUN usermod -aG docker jenkins