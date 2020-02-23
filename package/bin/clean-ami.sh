#!/usr/bin/env bash
# B A S H ! ! !


function delete_ami() {

  us_region_name="$1"
  ami_id="$2"

  my_array=( $(aws ec2 describe-images --image-ids $ami_id --region $us_region_name --output text --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId') )

  my_array_length=${#my_array[@]}

  echo "Deregistering AMI: $ami_id"

  aws ec2 deregister-image --image-id $ami_id --region $us_region_name
  EXIT_CODE=$?

  if [[ "${EXIT_CODE}" != "0" ]]; then

    echo -e "${ERROR} Deregistering Id:  $ami_id."
    return "$EXIT_CODE"
  fi

  echo "Removing Snapshot"

  for (( j=0; j<$my_array_length; j++ )) do

    temp_snapshot_id=""

    temp_snapshot_id=${my_array[$j]}

    echo "Deleting Snapshot: $temp_snapshot_id"

    aws ec2 delete-snapshot --snapshot-id $temp_snapshot_id --region $us_region_name
    EXIT_CODE=$?

    if [[ "${EXIT_CODE}" != "0" ]]; then

      echo -e "${ERROR} Deleting Snapshot:  $temp_snapshot_id"
      return "$EXIT_CODE"
    fi

  done

}

role="$1"

###  Delete all AMIs except the latest one

if [[ -n $role ]]; then
  ROLE_FILTER="Name=tag:role,Values=$role"
fi

DISTRO_FILTER="Name=tag:distro-id,Values=$DISTRO_ID"

echo "Distro Filter: $DISTRO_FILTER"

FINAL_FILTERS=" \"$DISTRO_FILTER\" \"$ROLE_FILTER\" "


QUERY='sort_by(Images, &CreationDate)[].{ID:ImageId,CreateDate:CreationDate,Role:Tags[?Key==`role`].Value,Distro:Tags[?Key==`distro-id`].Value}'

echo "Query: $QUERY"

script=$(printf "aws ec2 describe-images --owners self --filters %s  --query '%s' --output json" "$FINAL_FILTERS" "$QUERY")

echo "Script: $script"

#Run the script to get the AMIs then pass to JQ to delete the last array element from the soerted list
AMIs_TO_DELETE=$(/bin/sh -c "$script | jq 'del(.[-1])' ")

echo "TO Delete: $AMIs_TO_DELETE"

# THEN RUN it through JQ again only getting the IDs
values=( `echo $AMIs_TO_DELETE | jq -r '.[].ID' ` )

array_length=${#values[@]}

for (( i=0; i<$array_length; i++ )) do

  AMI_ID=""

  AMI_ID=${values[$i]}

  echo "Begin Deleting: $AMI_ID"

  delete_ami $AWS_DEFAULT_REGION $AMI_ID
  EXIT_CODE=$?

  if [[ "${EXIT_CODE}" != "0" ]]; then

    echo -e "${ERROR} Error Deleting AMI:  $AMI_ID"
    exit "$EXIT_CODE"
  fi

  echo "Done Deleting: $AMI_ID"
  echo ""

done
