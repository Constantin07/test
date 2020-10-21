#!/usr/bin/env bash

SITE='http://kubernetes-dashboard.internal:30000'

test_KubernetesDashboardIsUp() {
  result=`curl -sSf --retry 3 -o /dev/null -w "%{http_code}" "$SITE"`
  assertEquals "Site is up" "${result}" '200'
}

# Load shUnit2
. /usr/local/bin/shunit2
