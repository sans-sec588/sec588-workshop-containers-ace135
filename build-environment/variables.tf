variable "region" {
  type        = string
  description = "Please enter your AWS Region, if you are not sure use us-east-1"
  default     = "us-east-2"
}

variable "profile" {
  type        = string
  description = "Please create your profile here, if unsure put in default"
}

variable "bucket" {
  type        = string
  description = "This is the default bucket and it already exists in the cloud"
  default     = "aviata-tlpred"
}