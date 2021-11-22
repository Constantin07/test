#!/usr/bin/env bash

SITE='https://hello-kubernetes.internal:30001'

test_HelloKubernetesIsAccessible() {
  result=`curl -ksSfL --retry 5 -o /dev/null -w "%{http_code}" "$SITE"`
  assertEquals "Site is up" "${result}" '200'
}

# Load shUnit2
. /usr/local/bin/shunit2
