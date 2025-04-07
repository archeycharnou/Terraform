#####################################
# VPC VARS
#####################################

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b"]
}

#####################################
# PROVIDER VARS
#####################################

variable "aws_access" {
  default = "access"
}

variable "aws_secret" {
  default = "secret"
}

variable "region" {
  default = "us-west-2"
}
