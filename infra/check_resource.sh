#!/bin/bash

resource_url="$1"
expected_text="$2"

while true; do
    response=$(curl -s "$resource_url")
    
    if [ $? -eq 0 ]; then
        if [[ $response == *"$expected_text"* ]]; then
            echo "Ресурс доступен и содержит текст '$expected_text'."
            exit 0
        else
            echo "Ресурс доступен, но не содержит текст '$expected_text'."
            exit 1
        fi
    else
        echo "Попытка подключения..."
        sleep 10
    fi
done
