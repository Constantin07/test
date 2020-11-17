#!/usr/bin/env bash

set -eu

DOCKER_CONTENT_TRUST=0
DOCKER_IMAGE="docker-bench-security"

EXCLUDE_CHECKS=(
docker_swarm_configuration
docker_swarm_configuration_level1
docker_enterprise_configuration
docker_enterprise_configuration_level1
)

# return a comma separated list
function join () {
    local IFS="$1"
    shift
    echo "$*"
}

echo "$(join , ${EXCLUDE_CHECKS[@]})"

docker run --rm --net host --pid host --userns host --cap-add audit_control \
  -e DOCKER_CONTENT_TRUST=${DOCKER_CONTENT_TRUST} \
  -v /etc:/etc:ro \
  -v /usr/bin/containerd:/usr/bin/containerd:ro \
  -v /usr/bin/runc:/usr/bin/runc:ro \
  -v /usr/lib/systemd:/usr/lib/systemd:ro \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --label docker_bench_security \
  "${DOCKER_IMAGE}" -e "$(join , ${EXCLUDE_CHECKS[@]})"
