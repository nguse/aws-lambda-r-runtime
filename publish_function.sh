#!/bin/bash

set -euo pipefail

zip function.zip script.r

aws lambda create-function \
  --function-name nrt-precipitation-potential-forecast \
  --zip-file fileb://function.zip \
  --handler script.handler \
  --runtime provided \
  --timeout 60 \
  --layers arn:aws:lambda:us-east-1:474371642278:layer:r-runtime:1 \
  --role arn:aws:iam::474371642278:role/nrt-precipitation-potential-forecast-lambda \
  --region us-east-1

echo "next, test_function.sh"
