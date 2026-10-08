variable "env" {
  type        = string
  description = "The environment name"

  validation {
    condition     = contains(["stage", "prod"], var.env)
    error_message = "The env variable must be either \"stage\" or \"prod\"."
  }
}

variable "db_password" {
  type        = string
  description = "The password for the RDS database"
  sensitive   = true
}
