
#!/usr/bin/env bash
# B A S H ! ! !

#Note: bucket name is defined in tf-params-init.bash

eval "aws s3api head-bucket --bucket ${BUCKET_NAME} --region ${REGION_ID} >/dev/null 2>&1"
EXIT_CODE="$?"

#This is an error if the bucket already exists
if [[ "${EXIT_CODE}" == "0" ]]; then

  echo "${ERROR} The bucket ${BUCKET_NAME} already exists. Contact Devops for assistance"
  exit "$EXIT_CODE"

fi
