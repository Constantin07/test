#!/usr/bin/env bash

SITE='http://hello-kubernetes.internal:30000'

test_HelloKubernetesIsUp() {
  result=`curl -sSfL --retry 3 -o /dev/null -w "%{http_code}" "$SITE"`
  assertEquals "Site is up" "${result}" '200'
}

# Load shUnit2
. /usr/local/bin/shunit2
