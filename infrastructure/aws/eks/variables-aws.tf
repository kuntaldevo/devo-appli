
variable "region-id" {
  description = "To set the AWS provider's region.  Elsewhere use local.region-id resource that is populated by data.aws_region"
}

variable "profile-id" {
  description = "The AWS Profile to use on the local machine. This profile is usually `default` "
}

variable "account-id" {
  description = "To set the AWS provider's region.  Elsewhere use local.account-id resource that is populated by data.aws_caller_identity"
}

variable "aws-key-pair" {
  description = "The key pair that is assigned to the worker nodes for ssh access."
}

variable "provided-iam-instance-profile-arn" {
  default = ""
}

variable "provided-eks-cluster-role-arn" {
  default = ""
}

variable "provided-worker-node-role-arn" {
  default = ""
}
