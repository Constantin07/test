FROM docker.elastic.co/beats/metricbeat:6.2.3

ADD metricbeat.yml /usr/share/metricbeat/

USER root
RUN chown root:metricbeat /usr/share/metricbeat/metricbeat.yml

USER metricbeat
