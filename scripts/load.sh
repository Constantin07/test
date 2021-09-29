#!/usr/bin/env bash

site='http://hello-kubernetes.internal'

while true; do
  curl -sSfL -w "%{http_code}\n" -o /dev/null -m 2 "${site}" 2>&1
  sleep 0.3
done
