variable "ec2_ami_id" {
  description = "EC2 instance ami id"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_id" {
  description = "security group id"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "private_subnet_ids" {
  description = "list of private subnet ids"
  type        = list
}

variable "public_subnet_ids" {
  description = "list of public subnet ids"
  type        = list
}

variable "min_instance_count" {
  description = "minimum number of EC2 intance count"
  type        = number
}

variable "max_instance_count" {
  description = "maximum number of EC2 intance count"
  type        = number
}