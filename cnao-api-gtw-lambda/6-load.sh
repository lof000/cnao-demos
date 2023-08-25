#!/bin/bash
set -eo pipefail
APIID=$(aws cloudformation describe-stack-resource --stack-name nodejs-apig --logical-resource-id api --query 'StackResourceDetail.PhysicalResourceId' --output text)
REGION=$(aws configure get region)

while true; do  
   curl https://$APIID.execute-api.$REGION.amazonaws.com/api/ -v
  sleep 2
done