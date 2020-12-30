# Version 1.0.2

FROM jeromeklam/u20_java11
MAINTAINER Jérôme KLAM, "jeromeklam@free.fr"

# ENV
ENV DEBIAN_FRONTEND noninteractive
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:en
ENV LC_ALL fr_FR.UTF-8
ENV VERSION 9.0.41

## Installation des utilitaires de base
RUN apt-get update

## Création d'un user spécifique pour tomcat
RUN useradd -m -U -d /opt/tomcat -s /bin/false tomcat

## Install tomcat
RUN wget https://www-eu.apache.org/dist/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz -P /tmp
RUN tar -xf /tmp/apache-tomcat-${VERSION}.tar.gz -C /opt/tomcat/
RUN ln -s /opt/tomcat/apache-tomcat-${VERSION} /opt/tomcat/latest
RUN chown -R tomcat: /opt/tomcat
RUN sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

## Env for Catalina
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV JAVA_OPTS -Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true
ENV CATALINA_BASE /opt/tomcat/latest
ENV CATALINA_HOME /opt/tomcat/latest
ENV CATALINA_PID /opt/tomcat/latest/temp/tomcat.pid
ENV CATALINA_OPTS -Xms512M -Xmx1024M -server -XX:+UseParallelGC
ENV PATH $PATH:$CATALINA_HOME/bin

# Tomcat config & Users
COPY docker/tomcat-users.xml /opt/tomcat/latest/conf/
COPY docker/host-manager.xml /opt/tomcat/latest/webapps/host-manager/META-INF/context.xml 
COPY docker/manager.xml /opt/tomcat/latest/webapps/manager/META-INF/context.xml 

# Ports
EXPOSE 8080

# Volumes
RUN mkdir -p /opt/java
VOLUME /opt/apache-tomcat9/webapps
VOLUME /opt/java
VOLUME /root/.m2/repository/

# End
CMD ["catalina.sh", "run"]
