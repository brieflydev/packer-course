variable "image_name" {
  type        = string
  description = "Base name for the Docker repository and the AMI."
  default     = "nginx-web"
}

variable "image_version" {
  type        = string
  description = "Semantic version of the image, for example 1.0.0."
  default     = "1.0.0"
}