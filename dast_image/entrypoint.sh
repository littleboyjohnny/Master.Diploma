#!/bin/bash

set -e

host="app"
port="80"
cmd="$@"

>&2 echo "!!!!!!!! Check seafile for available !!!!!!!!"

while [ -z $(curl -v --silent http://$host:$port 2>&1 | grep -o '< HTTP/.* [^5][0-9][0-9]') ]; do
  >&2 echo "!!!!!!!! Seafile is not available, will try again in 10 seconds... !!!!!!!!"
  sleep 10
done

>&2 echo "!!!!!!!! Seafile is now available !!!!!!!!"

exec $cmd
