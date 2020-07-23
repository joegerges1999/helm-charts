FROM openjdk:8-jre-alpine
MAINTAINER Maikel Dollé <maikel@itmagix.nl>
RUN adduser -D -u 666 fitnesse
ARG release=20180127
ENV FNREL=$release
RUN mkdir -p /opt/fitnesse
RUN wget -O "/opt/fitnesse/fitnesse-standalone.jar" "http://www.fitnesse.org/fitnesse-standalone.jar?responder=releaseDownload&release=$FNREL" && \
    chown fitnesse.fitnesse /opt/fitnesse
COPY plugins.properties /opt/fitnesse/plugins.properties
ADD start.sh /start.sh
RUN chmod o+x /start.sh
ENTRYPOINT ["/start.sh"]
