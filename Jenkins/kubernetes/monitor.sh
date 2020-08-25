#!/usr/bin/env bash

# Monitor connectivity to an app deployed to K8s.

APP="http://hello-kubernetes.internal"

GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

function log() {
  local msg=$1
  echo -e "$(date) - ${msg}"
}

while true; do
  sleep 1
  http_code=`curl -s -o /dev/null -w %{http_code} ${APP}`
  [[ $http_code =~ 2[0-9][0-9] ]] && (log "${GREEN}${http_code}${NC}"; continue)
  [[ $http_code =~ 3[0-9][0-9] ]] && (log "${YELLOW}${http_code}${NC}"; continue)
  if [[ $http_code == "000" ]] || [[ $http_code =~ [4-5][0-9][0-9] ]]; then
    log "${RED}Failed to get URL${NC}"; continue
  fi
done
