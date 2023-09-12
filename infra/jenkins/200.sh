#!/bin/bash

url="https://$1"
if [ -z "$1" ]; then
    echo "Usage: $0 <URL> <text_to_search>"
    exit 1
fi

text_to_search="$2"
response_code=$(curl -s -o /dev/null -w "%{http_code}" -L "$url")

if [ "$response_code" -eq 200 ]; then
    echo "The web resource $url is accessible (HTTP 200 OK)."
    if curl -s "$url" | grep -q "$text_to_search"; then
        echo "Text '$text_to_search' found on the page."
        exit 0  # Успешное завершение
    else
        echo "Text '$text_to_search' not found on the page."
        exit 1  # Неуспешное завершение
    fi
else
    echo "The web resource $url is not accessible or returned a non-200 status."
    exit 1  # Неуспешное завершение
fi

