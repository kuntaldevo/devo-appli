

variable "do-eks"{

 default = "1"

  description = "Creating an actual EKS cluster takes about 10 minutes.  Set this to Zero to prevent the start up of EKS but still provision the networking."
}
