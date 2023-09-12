#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

domain="$1"
url="https://$domain"

ab -n 100 -c 10 "$url"