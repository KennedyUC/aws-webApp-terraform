output "vpc_id" {
  description = "vpc id"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "list of public subnet ids"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "list of private subnet ids"
  value       = aws_subnet.private_subnets[*].id
}

output "security_group_id" {
  description = "security group id"
  value       = aws_security_group.security_group.id
}