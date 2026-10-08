output "alb_dns_name" {
  description = "DNS name of the web application load balancer."
  value       = aws_alb.webserver_alb.dns_name
}
