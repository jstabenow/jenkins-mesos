FROM ubuntu:14.04

ENV MESOS_VERSION 0.28.1-2.0.20

RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && \
    apt-get install -y wget openjdk-7-jre-headless git-core unzip apache2-utils && \
    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - && \
    echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list && \
    apt-get update && \
    apt-get install -y jenkins && \
    mkdir -p /var/lib/jenkins/plugins && \
    (cd /var/lib/jenkins/plugins && wget --no-check-certificate http://updates.jenkins-ci.org/latest/mesos.hpi)

ADD config.xml /config.xml

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list && \
    apt-get update && \
    apt-get -y install mesos=${MESOS_VERSION}.ubuntu1404 && \
    locale-gen en_US.UTF-8

RUN mkdir /mnt/mesos && \
    mkdir /mnt/mesos/sandbox

ENV JENKINS_HOME "/var/lib/jenkins"
ENV JENKINS_LOGFILE "/mnt/mesos/sandbox/jenkins.log"
ENV JENKINS_MESOS_NAME "MesosCloud"
ENV JENKINS_MESOS_MASTER "zk://leader.mesos:2181/mesos"
ENV JENKINS_MESOS_DESCRIPTION "Jenkins Schedule"
ENV JENKINS_MESOS_FRAMEWORKNAME "Mesos"
ENV JENKINS_MESOS_SLAVEUSER "root"
ENV JENKINS_MESOS_PRINCIPAL ""
ENV JENKINS_MESOS_SECRET ""
ENV JENKINS_MESOS_ONDEMANDREGISTRATION "false"
ENV JENKINS_MESOS_JENKINSURL "http://jenkins.marathon.mesos:31205"
ENV JENKINS_MESOS_SLAVE_LABEL "mesos"
ENV PORT0 31205

VOLUME /var/lib/jenkins

ADD run.sh /bin/run.sh
RUN chmod +x /bin/run.sh

CMD ["run.sh"]
