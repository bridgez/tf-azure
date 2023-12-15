# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "A prefix used for all resources in this example"
  default = "bridge1215"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "East US"
}

variable "username" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "azuser"
}

variable "password" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "Passw0rd!23"
}
