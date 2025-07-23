# ----------------------
# FILE: variables.tf
# ----------------------

variable "db_password" {
  description = "The password for the RDS PostgreSQL database."
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secret used for signing JWTs"
  type        = string
  sensitive   = true
}

variable "cookie_secret" {
  description = "Secret used for signing cookies"
  type        = string
  sensitive   = true
}
