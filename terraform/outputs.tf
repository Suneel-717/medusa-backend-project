# ----------------------
# FILE: outputs.tf
# ---------------------

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.medusa_postgres.endpoint
  sensitive   = true
}
