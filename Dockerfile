FROM ubuntu:14.04

RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && \
    apt-get install -y wget openjdk-7-jre-headless git-core unzip apache2-utils && \
    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - && \
    echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list && \
    apt-get update && \
    apt-get install -y jenkins && \
    mkdir -p /var/lib/jenkins/plugins && \
    (cd /var/lib/jenkins/plugins && wget --no-check-certificate http://updates.jenkins-ci.org/latest/mesos.hpi)

ADD config.xml /var/lib/jenkins/config.xml

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]') && \
    CODENAME=$(lsb_release -cs) && \
    echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list && \
    apt-get -y update && \
    apt-get install -y mesos && \
    locale-gen en_US.UTF-8

RUN mkdir /mnt/mesos && \
    mkdir /mnt/mesos/sandbox

ENV JENKINS_HOME /var/lib/jenkins

VOLUME /var/lib/jenkins