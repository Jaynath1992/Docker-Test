FROM ubuntu:14.04
MAINTAINER Weldon Ng <weldon.ng@nuance.com>

ENV HTTP_PROXY 'http://s2tk-squid-vs.vrli.net:3128'
ENV HTTPS_PROXY 'https://s2tk-squid-vs.vrli.net:3128'

# Make sure the package repository is up to date.
RUN apt-get update
# Install a basic SSH server
RUN apt-get install -y subversion
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 8 (latest edition)
RUN apt-get install -y openjdk-8-jdk

# Standard SSH port
EXPOSE 22


ENV HOME /home/jenkins
RUN addgroup -S -g 10000 jenkins
RUN adduser -S -u 10000 -h $HOME -G jenkins jenkins
RUN echo "jenkins:jenkins" | chpasswd
RUN chown jenkins:jenkins $HOME


ARG AGENT_WORKDIR=/home/jenkins/agent


RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/3.19/remoting-3.19.jar
RUN chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar
RUN apt-get install -y python python-dev py-pip build-base \
  && pip install virtualenv


RUN apt-get install -y chromium-browser chromium-chromedriver xvfb

USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

CMD ["/usr/sbin/sshd", "-D"]
