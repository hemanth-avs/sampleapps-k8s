FROM centos:latest

MAINTAINER hemanth.avs@gmail.com

RUN mkdir -p /java/
COPY jre8u265/ /java/

RUN groupadd -g 1001 java \
    && useradd -r -u 1001 -g java java

RUN mkdir /data \
    && chown java:java /data

ENV PATH=/java/bin:$PATH 
USER java
