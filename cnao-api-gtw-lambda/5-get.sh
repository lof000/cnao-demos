#!/bin/bash
set -eo pipefail
APIID=$(aws cloudformation describe-stack-resource --stack-name nodejs-apig --logical-resource-id api --query 'StackResourceDetail.PhysicalResourceId' --output text)
REGION=$(aws configure get region)

echo "Calling..."
echo https://$APIID.execute-api.$REGION.amazonaws.com/api/ 

curl https://$APIID.execute-api.$REGION.amazonaws.com/api/ -v