variable "INSTANCE_TYPE" {
  type        = string
  description = "instance_type"
}
variable "KEY_PAIR" {
  type = string
}

variable "AMI" {
  description = "AMI"
}

variable "PUBLIC_SUBNET_ID" {
  type = string
}

variable "MAIN_VPC_ID" {
  type = string
}

variable "EGRESS_CIDR" {
  type = string
}

variable "INGRESS_CIDER" {
  type = string
}
