#!/bin/bash
set -eo pipefail
FUNCTION=$(aws cloudformation describe-stack-resource --stack-name nodejs-apig --logical-resource-id function --query 'StackResourceDetail.PhysicalResourceId' --output text)

echo "Instrumenting ...." $FUNCTION

aws lambda update-function-configuration --function-name $FUNCTION --no-cli-pager --layers arn:aws:lambda:us-east-1:184161586896:layer:opentelemetry-nodejs-0_2_0:1





