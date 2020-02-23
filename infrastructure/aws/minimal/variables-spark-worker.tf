
variable "spark-worker-count" {
  type = string
}

variable "feature-spark-cache-esb" {
  default = false
  description = "When simpler instance types like M5 and T3 that do not have SSDs then if we want to have a cache for spark we need to do some work in creating volume names and the actual volumes and mounting them etc."
}

# Removed the default because this is actually dependent on the AMI configuration and type
variable "spark-worker-cache-volume-count" {
  type = string
  default = 0
}
