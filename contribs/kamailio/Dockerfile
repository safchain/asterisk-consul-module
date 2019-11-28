FROM kamailio/kamailio:5.3.1-buster

MAINTAINER Sylvain Boily "sboily@wazo.io"

ENV VERSION 0.10.0

RUN apt-get -yqq update && apt-get -yqq install procps

WORKDIR /usr/src
ADD https://releases.hashicorp.com/consul-template/${VERSION}/consul-template_${VERSION}_linux_amd64.zip /usr/src/
# RUN tar xfvz consul-template_${VERSION}_linux_amd64.tgz
RUN unzip consul-template_${VERSION}_linux_amd64.zip
RUN mv consul-template /usr/bin

ADD ./config/kamailio/* /etc/kamailio/
ADD ./config/consul-template/* /config/

EXPOSE 5060/udp

CMD consul-template -log-level debug -config /config/template.hcl
ENTRYPOINT consul-template -log-level debug -config /config/template.hcl