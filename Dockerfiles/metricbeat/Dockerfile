FROM docker.elastic.co/beats/metricbeat:6.2.2

ADD metricbeat.yml /usr/share/metricbeat/

USER root
RUN chown root:metricbeat /usr/share/metricbeat/metricbeat.yml

USER metricbeat
