

if [[ "${PROVIDER_ID}" == "$AWS" ]]; then

  export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
  export USER_ID=$(aws sts get-caller-identity --output text --query 'UserId')
  export USER_ROLE=$(aws sts get-caller-identity --output text --query 'Arn')

fi
