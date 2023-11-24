variable "region" {
  description = "Azure infrastructure region"
  type        = string
  default     = "eastus"
}

variable "app" {
  description = "Application that we want to deploy"
  type        = string
  default     = "myapp"
}
variable "aca_name" {
  description = "Application that we want to deploy"
  type        = string
  default     = "devopstask"
}

variable "env" {
  description = "Application env"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Location short name "
  type        = string
  default     = "eastus"
}
