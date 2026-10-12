
variable "name_prefix" {
  description = "Prefix for RDS resource names"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for the database"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the database security group"
  type        = string
}

variable "ecs_security_group_id" {
  description = "Security group allowed to access PostgreSQL"
  type        = string
}

variable "db_name" {
  description = "Name of the application database"
  type        = string
  default     = "hotel_booking"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated database storage in GiB"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Automated backup retention in days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
