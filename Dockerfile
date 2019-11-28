#from quintana/asterisk:latest
from debian:buster

MAINTAINER Sylvain Boily <sboily@avencall.com>

WORKDIR /tmp
RUN apt-get update
RUN apt-get install -y software-properties-common wget gnupg
RUN add-apt-repository 'deb http://mirror.wazo.community/debian pelican-buster main'
RUN wget http://mirror.wazo.community/wazo_current.key
RUN apt-key add wazo_current.key
RUN apt-get update
RUN apt-get -y install asterisk asterisk-dev librabbitmq-dev make gcc libcurl4-openssl-dev git jq wazo-res-stasis-amqp wazo-res-amqp


# Install Asterisk consul module
WORKDIR /usr/src
ADD . /usr/src/asterisk-consul-module
WORKDIR /usr/src/asterisk-consul-module
RUN CFLAGS=-g make
RUN make install
RUN make samples

# Install AMQP module
#WORKDIR /usr/src
#run git clone https://github.com/wazo-platform/wazo-res-amqp
#WORKDIR /usr/src/wazo-res-amqp
#RUN CFLAGS=-g make
#RUN make install
#RUN make samples

# Install AMQP stasis module
WORKDIR /usr/src
run git clone https://github.com/wazo-platform/wazo-res-stasis-amqp
WORKDIR /usr/src/wazo-res-stasis-amqp
#RUN CFLAGS="-g -I/usr/src/wazo-res-amqp" make
#RUN make install
#RUN make samples
RUN cp amqp.json /usr/share/asterisk/rest-api
RUN bin/patch_ari_resources.sh

WORKDIR /root
RUN rm -rf /etc/asterisk/*
ADD res_discovery_consul.conf.sample /etc/asterisk/res_discovery_consul.conf
ADD contribs/asterisk/*.conf /etc/asterisk/
ADD stasis_amqp.conf.sample /etc/asterisk/stasis_amqp.conf
ADD amqp.conf.sample /etc/asterisk/amqp.conf
ADD res_discovery_consul.conf.sample /etc/asterisk/res_discovery_consul.conf

#RUN rm -rf /usr/src/*

ENTRYPOINT /usr/sbin/asterisk -f
