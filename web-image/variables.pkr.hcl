variable "image_name" {
  type        = string
  description = "Base name for the Docker repository and the AMI."
  default     = "nginx-web"
}

variable "image_version" {
  type        = string
  description = "Semantic version of the image, for example 1.0.0."
  default     = "1.0.0"
  
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.image_version))
    error_message = "The image_version must be a semantic version like 1.2.3."
  }
}

variable "status_password" {
  type        = string
  description = "Password for the protected /nginx_status page (user: admin)."
  sensitive   = true

  validation {
    condition     = length(var.status_password) >= 12
    error_message = "The status_password must be at least 12 characters long."
  }
}