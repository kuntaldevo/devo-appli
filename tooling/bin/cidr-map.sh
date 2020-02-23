#!/usr/bin/env bash
# B A S H ! ! !

###
# Validate required Env Vars exist
if [ -z "$REGION_ID" ]; then
    echo "Required Env Var REGION_ID is missing."
    exit 1
fi

# At the moment, One Parameter, the filter criteria

AWS_SERVICE_TYPE=`echo $1 | awk '{print toupper($0)}'`
aws_service_type=`echo $1 | awk '{print tolower($0)}'`

JQ_REGION_FILTER=" .[] | select(.region==\"${REGION_ID}\" and .service==\"${AWS_SERVICE_TYPE}\" )"

AWK="{ print \"  { cidr = \"\$0\", description = \42"${AWS_SERVICE_TYPE}.${REGION_ID}"\42 }, \"} "
# \42 is used to put in a double quote and not confuse AWK

URL="https://ip-ranges.amazonaws.com/ip-ranges.json"

echo "${aws_service_type}-cidr-map = ["

curl -s $URL | jq .prefixes | jq "${JQ_REGION_FILTER}"  | jq .ip_prefix | sort | uniq | awk "${AWK}"

echo "]"
echo ""
echo "Don't forget to remove the final comma ^^^"
