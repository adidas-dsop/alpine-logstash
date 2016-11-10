FROM dsop/alpine-base

ENV LOGSTASH_VERSION 2.4.0
ENV LOGSTASH_UID 1000

RUN mkdir /opt && \
  cd /opt && \
  curl -L https://download.elastic.co/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz -o logstash-${LOGSTASH_VERSION}.tar.gz && \
  tar xzf logstash-${LOGSTASH_VERSION}.tar.gz && \
  ln -s logstash-${LOGSTASH_VERSION} logstash && \
  ln -s /opt/logstash/bin/logstash /usr/local/bin/

RUN apk --update add openjdk8-jre

RUN cd /opt/logstash && bin/logstash-plugin install logstash-output-amazon_es

RUN adduser -u ${LOGSTASH_UID} -D logstash -s /bin/bash
RUN cp /root/.bashrc /home/logstash && \
  chown -R ${LOGSTASH_UID}:${LOGSTASH_UID} /home/logstash

USER logstash
WORKDIR /home/logstash

EXPOSE 5000-5010
EXPOSE 5000-5010/udp

ENTRYPOINT ["logstash", "-f", "/etc/logstash.conf", "--log", "/home/logstash/logstash.log"]
