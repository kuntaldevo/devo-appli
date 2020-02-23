#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${DIR}/lib/constants.bash"

# Set the Customer Id to their username, finding their name from Git's user.email
#export USER=`git config user.email | awk -F"@" '{print $1}' `

# Validate, expects a single input.  This input will be merged with 'aws-' and used to perform the access key lookup in ~/.aws/crededentials
if [[ -z "$1" ]]; then
  echo "${ERROR}A single parameter is required!"
  exit 1
fi


echo "${FYI}Using SAML2AWS $1"


SECRET="$(cat ~/.ssh/$1.mfa)"
TOKEN="$(oathtool --base32 --totp $SECRET)"

echo "${FYI}Received MFA Token ${TOKEN}"

exec $DIR/saml-aws-mfa.sh ${TOKEN}
