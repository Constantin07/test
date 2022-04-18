#!/usr/bin/env bash

set -u

timeout=5
max_retry=60
count=1
RC=1

until [[ ${RC} -eq 0 || ${count} -eq ${max_retry} ]]; do
    result=`kubectl top node 2>&1`
    RC=$?
    echo "${result}"
    echo "Waiting for metrics-server to become available, next retry ${count} in ${timeout} seconds."
    sleep ${timeout}
    ((count++))
done

if [ ${count} -eq ${max_retry} ]; then
    echo "Maximum ${max_retry} retrie(s) reached. Exiting ..."
    exit 1
fi
