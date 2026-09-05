#!/bin/bash

echo "the program is running"

change=n
api=""
port=""

while true; do
    read -p "You wanna change the api or the port? " change
    if [ "$change" == "y" ]; then
        read -p "Introduce a APIs name: " api
        read -p "Introduce a PORT: " port
        if [ -z "$api" ] || [ -z "$port" ]; then
            break
        fi
        change="n"
    elif [ -z "$change" ]; then
        break
    fi

    echo "the endpoint must not start with /"
    read -p "Introduce a Endpoit name: " endpoint
    if [ "$endpoint" == "end" ]; then
        break
    elif [ "$endpoint" == "prob" ]; then
        continue
    fi

    read -p "Introduce a method: " method
    if [ "$method" == "end" ]; then
        break
    elif [ "$method" == "prob" ]; then
        continue
    fi

    if [ -z "$method" ]; then
        curl="curl https://localhost:$port/$api/$endpoint"
        echo "curl: $curl"
        $curl
    else
        body="{"
        while true; do
            read -p "Introduce key value" key value
            if [ -z "$key" ]; then
                body="${body%,}"
                body="$body}"
                break
            else
                body="$body$key:$value,"
            fi
        done
        curl_exe=(curl -X "$method" "https://localhost:$port/$api/$endpoint" -H "Content-Type: application/json" -d "$body")
        "${curl_exe[@]}"
    fi
done