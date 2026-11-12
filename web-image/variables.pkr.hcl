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

variable "aws_region" {
  type        = string
  description = "Region where the AMI is built."
  default     = "eu-central-1"
}

variable "instance_type" {
  type        = string
  description = "Instance type of the temporary build instance."
  default     = "t3.micro"
}

variable "ami_regions" {
  type        = list(string)
  description = "Extra regions to copy the finished AMI to. Every copy is billed."
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "Subnet for the build instance. Leave null to use the default VPC."
  default     = null
}

variable "extra_tags" {
  type        = map(string)
  description = "Additional tags for the AMI and its snapshots."
  default     = {}
}

locals {
  timestamp = formatdate("YYYYMMDD-hhmmss", timestamp())

  common_tags = merge(
    {
      Project   = var.image_name
      Version   = var.image_version
      ManagedBy = "packer"
    },
    var.extra_tags,
  )
}