FROM openjdk:8-jre

MAINTAINER Chen Wang <chen.wang@telus.com>

ENV ACTIVEMQ_VERSION=5.15.9 \
    ACTIVEMQ_TCP=61616 \
    ACTIVEMQ_HOME=/opt/activemq

ENV ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION    

COPY files/docker-entrypoint.sh /docker-entrypoint.sh
COPY files/users.properties /users.properties
COPY files/groups.properties /groups.properties
COPY files/activemq.xml /activemq.xml

RUN set -x && \
    curl -s -S https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz | tar xvz -C /opt && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    useradd -r -M -d $ACTIVEMQ_HOME activemq && \
    chown -R :0 /opt/$ACTIVEMQ && \
    chown -h :0 $ACTIVEMQ_HOME && \
    chmod go+rwX -R $ACTIVEMQ_HOME && \
	mv /users.properties $ACTIVEMQ_HOME/conf && \
	mv /groups.properties $ACTIVEMQ_HOME/conf && \ 
	mv /activemq.xml $ACTIVEMQ_HOME/conf && \ 
    chmod +x /docker-entrypoint.sh


RUN set -x && \


WORKDIR $ACTIVEMQ_HOME

EXPOSE 61616
EXPOSE 8161

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh", "-c", "bin/activemq console"]


