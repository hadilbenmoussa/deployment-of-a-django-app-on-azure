variable "region" {
  description = "Azure infrastructure region"
  type        = string
  default     = "eastus"
}


variable "aca_name" {
  description = "Application that we want to deploy"
  type        = string
  default     = "devopstask"
}


variable "location" {
  description = "Location short name "
  type        = string
  default     = "eastus"
}
