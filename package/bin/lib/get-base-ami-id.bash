
# Get the latest AMI id for the base-server

aws ec2 describe-images --owners 'self' --filters 'Name=tag:distro-id,Values=centos-7' 'Name=tag:role,Values=base-server'  --query 'sort_by(Images, &CreationDate)[-1].[ImageId]'
