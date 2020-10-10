#!/usr/bin/env bash

set -e

# Script to test docker-registry container is running

CONTAINER_NAME="${IMAGE_NAME:-docker-registry}"

retry=0
while [ $retry -le 5 ]; do
    if [[ $(docker inspect -f '{{.State.Running}}' ${CONTAINER_NAME}) == "true" ]]; then
	echo "Container ${CONTAINER_NAME} is running ..."
	exit 0
    fi
    echo "Waiting for ${CONTAINER_NAME} container to come up, retry=$retry"
    sleep 3
    ((retry+=1))
done

echo "Container ${CONTAINER_NAME} failed to start. Max $retry retries reached."
exit 1
