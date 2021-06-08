#!/bin/bash

set -e

cmd="$@"

>&2 echo "!!!!!!!! Check app for available !!!!!!!!"

while [ -z $(curl -v --silent http://iast:8080 2>&1 | grep -o '< HTTP/.* [^5][0-9][0-9]') ]; do
  >&2 echo "!!!!!!!! App is not available, will try again in 10 seconds... !!!!!!!!"
  sleep 10
done

>&2 echo "!!!!!!!! App is now available !!!!!!!!"

>&2 echo "!!!!!!!! Going to execute cmd: $cmd !!!!!!!!"

exec $cmd

