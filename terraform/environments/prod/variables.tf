variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "hotel-booking"
}

variable "db_password" {
  description = "Database password supplied securely at plan time"
  type        = string
  sensitive   = true
}