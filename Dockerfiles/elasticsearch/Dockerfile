FROM docker.elastic.co/elasticsearch/elasticsearch:6.2.2

ADD java.policy /usr/share/elasticsearch/
ADD elasticsearch.yml /usr/share/elasticsearch/config/

RUN mkdir -p /usr/share/elasticsearch/config/discovery-file && \
    chown elasticsearch /usr/share/elasticsearch/config/discovery-file && \
    chmod 0775 /usr/share/elasticsearch/config/discovery-file

ADD unicast_hosts.txt /usr/share/elasticsearch/config/discovery-file/
ADD java.security /usr/lib/jvm/jre-1.8.0-openjdk/lib/security/

RUN bin/elasticsearch-plugin install -b discovery-file && \
    bin/elasticsearch-plugin install -b repository-s3 && \
    bin/elasticsearch-plugin install -b mapper-murmur3
