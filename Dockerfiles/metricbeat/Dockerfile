FROM docker.elastic.co/beats/metricbeat:6.2.1

ADD metricbeat.yml /usr/share/metricbeat/

USER root
RUN chown metricbeat /usr/share/metricbeat/metricbeat.yml

USER metricbeat
