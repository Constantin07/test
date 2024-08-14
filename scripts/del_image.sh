#!/usr/bin/env bash

# Used to list and delete docker images from v2 registry

registry='registry.internal:5000'
name=$1
tag=$2
curl -sSL "http://${registry}/v2/${name}/tags/list" | jq -c '.tags | sort' | jq -r

curl -v -sSL -X DELETE "http://${registry}/v2/${name}/manifests/$(
    curl -sSL -I \
        -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        "http://${registry}/v2/${name}/manifests/${tag}" \
    | awk '$1 == "Docker-Content-Digest:" { print $2 }' \
    | tr -d $'\r' \
)"
