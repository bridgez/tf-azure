
# variables can be in main.tf, but it's a mess, so we seprate it

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "bridge1106"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "east asia"
}

variable "username" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "admin"
}

variable "password" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "Passw0rd!23"
}
