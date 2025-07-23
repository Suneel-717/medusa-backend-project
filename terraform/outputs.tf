# ----------------------
# FILE: outputs.tf
# ----------------------

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.medusa_alb.dns_name
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.medusa_postgres.endpoint
  sensitive   = true
}
