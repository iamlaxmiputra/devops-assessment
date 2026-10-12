
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

output "name_prefix" {
  description = "Prefix used to name infrastructure resources"
  value       = local.name_prefix
}

output "common_tags" {
  description = "Common tags applied to resources"
  value       = local.common_tags
}
