#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${DIR}/lib/constants.bash"

# Validate 'jq' is available
which jq > /dev/null
EXIT_CODE=$?
# Validate, expects a single input.  This input will be merged with 'aws-' and used to perform the access key lookup in ~/.aws/crededentials
if [[ $EXIT_CODE != "0" ]]; then
  echo "${ERROR}The JQ library is required!"
  exit $EXIT_CODE
fi

# Validate, expects a single input.  This input will be merged with 'aws-' and used to perform the access key lookup in ~/.aws/crededentials
if [[ -z "$1" ]]; then
  echo "${ERROR}A single parameter is required!"
  exit 1
fi


#If a user profile provided then use it, adding the Profile flag here
PROFILE_ID=""
if [[ -n "$2" ]]; then
  PROFILE_ID="--profile $2"
fi

echo "${FYI}Assuming Role $1 using $2"

ACCOUNT_ID=$(aws sts get-caller-identity $PROFILE_ID --output text --query 'Account' )
USER_ID=$(aws sts get-caller-identity $PROFILE_ID --output text --query 'Arn' | sed 's/arn:aws:iam::'"$ACCOUNT_ID:user\/"'//' )


# Set the time to the role the max time for the role as set in IAM
#MAX_ROLE_DURATION=$(aws iam get-role --role-name $1 --query "Role.MaxSessionDuration" $PROFILE_ID)
#EXIT_CODE="$?"
#
#if [[ $EXIT_CODE != "0" ]]; then
#  MAX_ROLE_DURATION="28800"
#fi

ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/$1"

CREDENTIALS="$( aws sts assume-role --role-arn $ROLE_ARN --role-session-name $USER_ID --duration-seconds 3600 $PROFILE_ID )"
EXIT_CODE="$?"

if [[ $EXIT_CODE != "0" ]]; then
  echo "${ERROR}Error performing assume-role with ARN:$ROLE_ARN"
  exit $EXIT_CODE
fi

echo "${FYI}AWS Returned these Credentials"
echo ${CREDENTIALS} | jq .
echo ""
echo ""
echo ""

ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')"
#echo "$ACCESS_KEY_ID"

SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')"
#echo "$SESSION_TOKEN"

SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')"
#echo "$SECRET_ACCESS_KEY"


aws configure set aws_access_key_id "$ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$SECRET_ACCESS_KEY"
aws configure set aws_session_token "$SESSION_TOKEN"

if [[ -z "$AWS_PROFILE" ]]; then
  echo "$FYI Displaying the Caller Identity using profile 'default'"
else
  echo "$FYI Displaying the Caller Identity using EXPLICIT profile '$AWS_PROFILE'. "
  echo "$WARN If this was unexpected then check your environment variables for AWS_PROFILE "
fi

aws sts get-caller-identity
EXIT_CODE="$?"

if [[ $EXIT_CODE == 0 ]]; then
  echo "${OK}Success!"
else
  echo "${ERROR}Failure"
fi
