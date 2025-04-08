#####################################
# VPC VARS
#####################################

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Public Subnet CIDRs"
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
  type = list(string)
  description = "Private Subnet CIDRs"
}

variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b"]
  type = list(string)
  description = "Availability Zones For Subnets"
}

#####################################
# PROVIDER VARS
#####################################

variable "aws_access" {
  default = "access"
  type = string
  description = "AWS Access Key"
}

variable "aws_secret" {
  default = "secret"
  type = string
  description = "AWS Secret Key"
  sensitive = true
}

variable "region" {
  default = "us-west-2"
  type = string
  description = "Region where Terraform will be applied"
}


#####################################
# ALB VARS
#####################################

variable "port" {
  default = 80
  type = number
  description = "Default Port"
}

#####################################
# DATABASE VARS
#####################################

variable "dbuser" {
  default = "admin"
  type = string
  description = "Database User Username"
  sensitive = true
}

variable "dbpass" {
  default = "password"
  type = string
  description = "Database User Password"
  sensitive = true
}