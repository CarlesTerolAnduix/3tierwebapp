variable "env" {
  type        = string
  description = "The environment name"

  validation {
    condition     = contains(["stage", "prod"], var.env)
    error_message = "The env variable must be either \"stage\" or \"prod\"."
  }
}

variable "multi_az" {
  type = bool
}

variable "deletion_protection" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}
