#
# Allow processes on nodes themselves to modify route53
#
# Creates Inline Policy so name does not have to be unique across clusters, regions etc

resource "aws_iam_role_policy" "node-policy" {

  count = local.create-instance-profile

  name = "route53-inline-policy"
  role = aws_iam_role.node[0].id

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "route53:ChangeResourceRecordSets"
     ],
     "Resource": [
       "arn:aws:route53:::hostedzone/*"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ListHostedZones",
       "route53:ListResourceRecordSets"
     ],
     "Resource": [
       "*"
     ]
   }
 ]
}
EOF
}
