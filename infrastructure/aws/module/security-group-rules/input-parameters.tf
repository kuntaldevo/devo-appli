#################
# Security group
#################
variable "create" {
  description = "Whether to create security group and all rules"
  default     = true
}

variable "sg-id" {
  description = "The Security Group we are going to assign the rules to."
}

variable "ingress-description" {
  description = "If the ingress rules do not have a key of 'description' then this will be the default"
  default = "Ingress Rule"
}

variable "egress-description" {
  description = "If the egress rules do not have a key of 'description' then this will be the default"
  default = "Egress Rule"
}


##########
# Ingress
##########
variable "ingress-cidr" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  default     = []
}

variable "ingress-rules" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  default     = []
}

#########
# Egress
#########

variable "egress-cidr" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  default     = ["0.0.0.0/0"]
}

variable "egress-rules" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  default     = []
}
