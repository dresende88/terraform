variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.28.0.0/16"
}

variable "vpc_cidr1" {
  description = "CIDR for the whole VPC"
  default     = "172.28.192.0/18"
}

variable "name" {
  default = "lab"
  type    = string
}

variable "environment" {
  default = "development"
  type    = string
}

variable "costcenter_id" {
  default = "0000000011"
  type    = string
}

variable "city" {
  default = "sp"
  type    = string
}

variable "country" {
  default = "br"
  type    = string
}