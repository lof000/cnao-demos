#!/bin/bash

set -eo pipefail
FUNCTION=$(aws cloudformation describe-stack-resource --stack-name nodejs-apig --logical-resource-id function --query 'StackResourceDetail.PhysicalResourceId' --output text)


L_ENVS=`tr -d '\n' < env_otel.txt`
echo $L_ENVS

echo "ADDIN ENV VARIABLES"

aws lambda update-function-configuration --function-name $FUNCTION --no-cli-pager \
    --environment "Variables={$L_ENVS}"