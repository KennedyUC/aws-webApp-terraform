variable "vpc_cidr" {
  description = "cidr block for the VPC"
  type        = string
}

variable "enable_vpc_dns" {
  description = "enable vpc dns"
  type        = bool
}

variable "project_name" {
  description = "name of the project"
  type        = string
}

variable "env" {
  description = "environment"
  type        = string
}

variable "subnet_count" {
  description = "subnet count"
  type        = number
}

variable "subnet_bits" {
  description = "number of subnet bits to use for the subnet"
  type        = number
}