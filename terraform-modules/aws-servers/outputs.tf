output "web_dns_name" {
  description = "The website URL DNS name or Public URL of the Load Balancer."
  value       = "http://${aws_lb.WebAppLB.dns_name}"
}