# Pull base image
FROM resin/rpi-raspbian:stretch
MAINTAINER Matias Uh <matias@mtu-it.com.ar>

# Install dependencies and setup environment variables
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get update && apt-get install -y oracle-java8-installer vim curl python3 python3-pip \
&&  rm -rf /var/lib/apt/lists/*
RUN pip3 install w1thermsensor rpi.gpio ipython


# Define working directory
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Set locales
RUN locale-gen es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LC_CTYPE es_ES.UTF-8

##########################################  INSTALACION DE TOMCAT ############################
ENV TOMCAT_VERSION 8.5.34

# Get Tomcat
RUN wget --quiet --no-cookies http://apache.rediris.es/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz

# Uncompress
RUN tar xzvf /tmp/tomcat.tgz -C /opt
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/tomcat.tgz

# Remove garbage
RUN rm -rf /opt/tomcat/webapps/examples
RUN rm -rf /opt/tomcat/webapps/docs
RUN rm -rf /opt/tomcat/webapps/ROOT

# Add admin/admin user
ADD ./files/tomcat-users.xml /opt/tomcat/conf/
ADD ./files/brewcontroller /usr/lib/brewcontroller

RUN ln -s /usr/lib/brewcontroller/brewcontroller.py /usr/bin/brewcontroller

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
VOLUME "/opt/tomcat/webapps"
WORKDIR /opt/tomcat

# Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]

