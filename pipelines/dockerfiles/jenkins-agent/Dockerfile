FROM adoptopenjdk/openjdk11:alpine-jre

# Install required packages

RUN apk --no-cache update && apk --no-cache upgrade && \
    apk add --no-cache ca-certificates git curl bash jq openssh-client openssl sudo iptables e2fsprogs make procps img && \
    update-ca-certificates

ENV JENKINS_HOME=/var/jenkins

# Add jenkins user

ARG USER=jenkins
ARG GROUP=jenkins
ARG UID=1000
ARG GID=1000
RUN addgroup -g ${GID} ${GROUP} && \
    adduser -h "${JENKINS_HOME}" -u ${UID} -G ${GROUP} -s /bin/bash -D ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${USER} && \
    chmod 440 /etc/sudoers.d/${USER} && \
    chown -R ${USER}:${GROUP} ${JENKINS_HOME} && \
    echo "${USER}:165536:65536" >> /etc/subuid && \
    echo "${GROUP}:165536:65536" >> /etc/subgid

# Add jenkins agent

ARG VERSION=4.8
RUN curl --create-dirs -sfSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar && \
    chmod 755 /usr/share/jenkins && \
    chmod 644 /usr/share/jenkins/agent.jar

# jenkins/inbound-agent

COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent

USER ${USER}

ENV AGENT_WORKDIR=${JENKINS_HOME}/agent
RUN mkdir ${JENKINS_HOME}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME ${JENKINS_HOME}/.jenkins
VOLUME ${AGENT_WORKDIR}

WORKDIR ${JENKINS_HOME}

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
