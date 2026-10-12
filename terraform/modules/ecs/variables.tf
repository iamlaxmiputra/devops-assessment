
variable "name_prefix" {
  description = "Prefix for ECS resource names"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "container_image" {
  description = "Docker image for the application"
  type        = string
  default     = "nginx:stable"
}

variable "container_port" {
  description = "Application container port"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
variable "vpc_id" {
  description = "VPC ID where ECS resources will be created"
  type        = string
}