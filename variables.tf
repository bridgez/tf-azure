# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "bridge1105"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "eastus"
}

variable "admin_password" {
  type    = string
  description = "The admin password for the virtual machine"
}

