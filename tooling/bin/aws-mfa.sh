#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${DIR}/lib/constants.bash"

# Validate 'jq' is available
which jq > /dev/null
EXIT_CODE=$?
# Validate, expects a single input.  This input will be merged with 'aws-' and used to perform the access key lookup in ~/.aws/crededentials
if [[ $EXIT_CODE != "0" ]]; then
  echo "${ERROR}The JQ library is required!"
  exit 1
fi

# Validate, expects a single input.  This input will be merged with 'aws-' and used to perform the access key lookup in ~/.aws/crededentials
if [[ -z "$1" ]]; then
  echo "${ERROR}A single parameter is required!"
  exit 1
fi


echo "${FYI}Performing MFA with profile $1"


ARN="$(cat ~/.aws/$1.arn)"
SECRET="$(cat ~/.aws/$1.mfa)"
TOKEN="$(oathtool --base32 --totp $SECRET)"

echo "${FYI}Received MFA Token ${TOKEN}"

CREDENTIALS="$( aws sts get-session-token --serial-number $ARN --token-code $TOKEN --profile $1 )"

if [[ $CREDENTIALS == "" ]]; then
  echo "${ERROR}Failure"
  exit 1;
fi


echo "${FYI}AWS Returned these Credentials"
echo ${CREDENTIALS} | jq .

ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')"
#echo "$ACCESS_KEY_ID"

SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')"
#echo "$SESSION_TOKEN"

SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')"
#echo "$SECRET_ACCESS_KEY"


aws configure set aws_access_key_id "$ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$SECRET_ACCESS_KEY"
aws configure set aws_session_token "$SESSION_TOKEN"

# if SAML2 AWS was previously used then we will need to clear out some others...
sed  -i '' '/^aws_security_token/d' ~/.aws/credentials
sed  -i '' '/^x_principal_arn/d' ~/.aws/credentials
sed  -i '' '/^x_security_token_expires/d' ~/.aws/credentials

#If a second parameter was set then assume that role and update the crededentials with that
if [[ -n "$2" ]]; then

  echo "Assuming Role $2"

  ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
  USER_ID=$(aws sts get-caller-identity --output text --query 'Arn' | sed 's/arn:aws:iam::'"$ACCOUNT_ID:user\/"'//')

# echo "USER ID -----   $USER_ID"

  CREDENTIALS="$( aws sts assume-role --role-arn arn:aws:iam::${ACCOUNT_ID}:role/$2 --role-session-name $USER_ID )"

  echo "#########################"
  echo ${CREDENTIALS} | jq .
  echo "#########################"

  ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')"
  #echo "$ACCESS_KEY_ID"

  SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')"
  #echo "$SESSION_TOKEN"

  SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')"
  #echo "$SECRET_ACCESS_KEY"


  aws configure set aws_access_key_id "$ACCESS_KEY_ID"
  aws configure set aws_secret_access_key "$SECRET_ACCESS_KEY"
  aws configure set aws_session_token "$SESSION_TOKEN"

fi

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
