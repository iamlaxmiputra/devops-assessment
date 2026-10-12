
variable "name_prefix" {
  description = "Prefix for ALB resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "target_port" {
  description = "Port exposed by the application container"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "HTTP health check path"
  type        = string
  default     = "/health"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
