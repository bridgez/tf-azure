
# variables can be in main.tf, but it's a mess, so we seprate it

variable "location" {
  type        = string
  description = "Location for resourceGroup"
  default     = "East Asia"
}

variable "rgname" {
  type        = string
  description = "name for resourceGroup"
  default     = "Terraform"

}
