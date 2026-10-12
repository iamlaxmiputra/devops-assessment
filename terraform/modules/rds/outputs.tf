
output "db_endpoint" {
  description = "RDS endpoint address and port"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Application database name"
  value       = aws_db_instance.main.db_name
}

output "db_security_group_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}
