#!/bin/bash

echo "the program is running"
basic="Content-Type: application/json"
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
    header="Content-Type: application/json"
    read -p "wanna try with authentification? y/n: " wanna
    if [ "$wanna" == "y" ]; then
        read -p "Introduce token: " token
        header="Authorization: Bearer $token"
    fi

    if [ -z "$method" ]; then
        if [ "$wanna" == "y" ]; then
            curl=(curl "http://localhost:$port/api/$api/$endpoint" -H "$header")
            echo "${curl[@]}"
            "${curl[@]}"
        else
            curl="curl http://localhost:$port/api/$api/$endpoint"
            echo "curl: $curl"
            $curl
        fi
    else
        body="{"
        while true; do
            read -p "Introduce key value: " key value
            if [ -z "$key" ]; then
                body="${body%,}"
                body="$body}"
                break
            else
                body="$body$key:$value,"
            fi
        done
        if [ "$wanna" == "y" ]; then
            curl_exe=(curl -X "$method" "http://localhost:$port/api/$api/$endpoint" -H "$header" -H "$basic" -d "$body")
            echo "${curl_exe[@]}"
            "${curl_exe[@]}"
        else
            curl_exe=(curl -X "$method" "http://localhost:$port/api/$api/$endpoint" -H "$header" -d "$body")
            echo "${curl_exe[@]}"
            "${curl_exe[@]}"
        fi
    fi
done