variable "public_subnet_ids" {
  description = "list of public subnet ids"
  type        = list
}

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

variable "security_group_id" {
  description = "db security group id"
  type        = string
}