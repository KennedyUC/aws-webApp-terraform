output "web_dns_name" {
  description = "The website URL DNS name or Public URL of the Load Balancer."
  value       = module.servers_config.web_dns_name
}