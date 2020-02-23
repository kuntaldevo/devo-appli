
#!/usr/bin/env bash
# B A S H ! ! !

eval "aws dynamodb describe-table --table-name ${ENV_KEY}.tflock --region ${REGION_ID} >/dev/null 2>&1"
EXIT_CODE="$?"

#This is an error if the dynamodb table already exists
if [[ "${EXIT_CODE}" == "0" ]]; then

  echo "${ERROR} The table ${ENV_KEY}.tflock in region ${REGION_ID} already exists.  Contact Devops for more assistance."
  exit "$EXIT_CODE"

fi
