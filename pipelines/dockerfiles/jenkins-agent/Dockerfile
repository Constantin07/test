# syntax=docker/dockerfile:1

FROM adoptopenjdk/openjdk11:alpine-jre

# Install required packages

RUN apk --no-cache update && apk --no-cache upgrade && \
    apk add --no-cache ca-certificates curl bash git git-lfs jq openssh-client openssl procps img && \
    update-ca-certificates

# Add jenkins user

ARG USER=jenkins
ARG GROUP=jenkins
ARG UID=10001
ARG GID=10001
RUN addgroup -g ${GID} ${GROUP} && \
    adduser -h /home/${USER} -u ${UID} -G ${GROUP} -D ${USER} && \
    echo "${USER}:165536:65536" >> /etc/subuid && \
    echo "${GROUP}:165536:65536" >> /etc/subgid && \
    mkdir -p /run/runc && chmod 777 /run/runc && \
    ln -s /usr/bin/img /usr/bin/docker

# Add jenkins agent

ARG VERSION
RUN curl --create-dirs -sfSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar && \
    chmod 755 /usr/share/jenkins && \
    chmod 644 /usr/share/jenkins/agent.jar

# jenkins/inbound-agent

COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent

ARG VAULT_ADDR
COPY add_ca_certs.sh add_ca_certs.sh
RUN chmod +x ./add_ca_certs.sh && \
    ./add_ca_certs.sh && \
    rm -f ./add_ca_certs.sh

USER ${USER}

ARG AGENT_WORKDIR=/home/${USER}/agent
ENV AGENT_WORKDIR=${AGENT_WORKDIR} \
    USER=${USER}
RUN mkdir /home/${USER}/.jenkins && mkdir -p ${AGENT_WORKDIR}

WORKDIR /home/${USER}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
