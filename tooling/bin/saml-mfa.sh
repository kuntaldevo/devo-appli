#!/usr/bin/env bash

source lib/constants.bash

#Define file for Curl Cookies
COOKIE_JAR="${HOME}/.saml-mfa-cookies"

# Validate 'jq' is available
which jq > /dev/null
EXIT_CODE=$?
# Validate, expects a single input.  This input will be merged with 'aws-' and used to perform the access key lookup in ~/.aws/crededentials
if [[ $EXIT_CODE != "0" ]]; then
  echo -e "${ERROR}The JQ library is required!"
  exit 1
fi

# Validate, expects a single input.  This input will be merged with 'aws-' and used to perform the access key lookup in ~/.aws/crededentials
if [[ -z "$1" ]]; then
  echo -e "${ERROR}A single parameter is required!"
  exit 1
fi

ARN="$(cat ~/.aws/$1.arn)"
SECRET="$(cat ~/.aws/$1.mfa)"
TOKEN="$(oathtool --base32 --totp $SECRET)"

echo "#########################"
echo "TOKEN: '${TOKEN}'"
echo "#########################"

XSRF_TOKEN=$(curl -c ${COOKIE_JAR} --url https://console.jumpcloud.com/userconsole/xsrf)
XSRF_TOKEN=$( echo "${XSRF_TOKEN}" | jq -r ".xsrf")

REDIRECT_URL=$(curl \
  -d "{\"Context\" : \"sso\", \"RedirectTo\" : \"saml2/aws\",\"Email\" : \"gbonk@paxata.com\",\"Password\" : \"pax\`1111\",  \"OTP\" : \"${TOKEN}\"}" \
  -X "POST" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "X-Xsrftoken: ${XSRF_TOKEN}" \
  -b ${COOKIE_JAR} \
  --url "https://console.jumpcloud.com/userconsole/auth" )

REDIRECT_URL=$( echo "${REDIRECT_URL}" | jq -r ".redirectTo")

echo "${REDIRECT_URL}"

SAML_ASSERT=$(curl \
  -X "GET" \
  -b ${COOKIE_JAR} \
  --url "${REDIRECT_URL}" )

echo $(xmllint --valid --html "${SAML_ASSERT}")

rm -rf ${COOKIE_JAR}

exit 0


CREDENTIALS="$( aws sts get-session-token --serial-number $ARN --token-code $TOKEN --profile $1 )"

if [[ $CREDENTIALS == "" ]]; then
  echo -e "${ERROR}Failure"
  exit 1;
fi


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

# if SAML2 AWS was previously used then we will need to clear out some others...
sed  -i '' '/^aws_security_token/d' ~/.aws/credentials
sed  -i '' '/^x_principal_arn/d' ~/.aws/credentials
sed  -i '' '/^x_security_token_expires/d' ~/.aws/credentials



aws sts get-caller-identity
EXIT_CODE="$?"

if [[ $EXIT_CODE == 0 ]]; then
  echo -e "${OK}Success!"
else
  echo -e "${ERROR}Failure"
fi
