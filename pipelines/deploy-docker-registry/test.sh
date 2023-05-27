#!/usr/bin/env bash

set -e

# Script to test docker-registry is up and running

REGISTRY="registry.internal:5000"

retry=0
while [ $retry -le 5 ]; do
    if [[ $(curl -I -k -s $REGISTRY | head -n 1 | cut -d ' ' -f 2) == "200" ]]; then
	echo "Docker registry ${REGISTRY} is up and running ..."
	exit 0
    fi
    echo "Waiting for docker registry '${REGISTRY}' to come up, retry=$retry"
    sleep 3
    ((retry+=1))
done

echo "Docker registry ${REGISTRY} failed to start. Max $retry retries reached."
exit 1
