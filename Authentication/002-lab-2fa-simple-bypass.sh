#!/bin/bash

source ../common.hook

MY_USERNAME='wiener'
MY_PASSWORD='peter'
USERNAME='carlos'
PASSWORD='montoya'

REQUEST=$(curl ${PS_URL}/login -X POST -d "username=${USERNAME}&password=${PASSWORD}" -c -)
COOKIE=$(echo ${REQUEST} | sed -n "s/.*session\s\(\S*\)$/\1/p")

curl ${PS_URL}/my-account/change-email -X POST -H "Cookie: session=${COOKIE}" -d "email=${EMAIL_URL}"

eval_result $PS_URL
