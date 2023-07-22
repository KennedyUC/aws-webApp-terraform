################################## Network Config ###################################
variable "project_name" {
  description = "name of the project"
  type        = string
}

variable "env" {
  description = "environment"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr block for the VPC"
  type        = string
}

variable "enable_vpc_dns" {
  description = "enable vpc dns"
  type        = bool
}

variable "subnet_count" {
  description = "subnet count"
  type        = number
}

variable "subnet_bits" {
  description = "number of subnet bits to use for the subnet"
  type        = number
}

################################## Servers Config ###################################

variable "ec2_ami_id" {
  description = "EC2 instance ami id"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "min_instance_count" {
  description = "minimum number of EC2 intance count"
  type        = number
}

variable "max_instance_count" {
  description = "maximum number of EC2 intance count"
  type        = number
}

################################## DB Config ###################################

variable "db_storage_size" {
  description = "storage size allocated to db engine"
  type        = number
}

variable "db_storage_type" {
  description = "db engine storage type"
  type        = string
}

variable "db_engine_type" {
  description = "type of db instance"
  type        = string
}

variable "db_engine_version" {
  description = "db instance version"
  type        = string
}

variable "db_instance_class" {
  description = "db intance class"
  type        = string
}

variable "db_name" {
  description = "db instance name"
  type        = string
}

variable "db_username" {
  description = "db instance root username"
  type        = string
}

variable "db_password" {
  description = "db instance root password"
  type        = string
}

########################## PROVIDER ##############################
variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "user_access_key" {
  description = "user access key"
  type        = string
}

variable "user_secret_key" {
  description = "user secret key"
  type        = string
}