# Configure the Azure provider
# The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision your infrastructure.
terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
      # 要求Terraform使用 azurerm 提供程序的3.0.2版本或更高的版本，但不升级到4.0.0或更高的主版本，以防止潜在的不兼容问题。
    }
  }
  cloud {
    organization = "bridgez"
    workspaces {
      name = "tf-azure"      
    }
}  
}
variable "ARM_CLIENT_ID" {
  description = "ARM_CLIENT_ID"
}
variable "ARM_CLIENT_SECRET" {
  description = "ARM_CLIENT_SECRET"
}
variable "ARM_SUBSCRIPTION_ID" {
  description = "ARM_SUBSCRIPTION_ID"
}

variable "ARM_TENANT_ID" {
  description = "ARM_TENANT_ID"
}


variable "azurerm_resource_group" {
  description = "resource group"
  default = "Terraform1106"
}

# The provider block configures the specified provider, in this case azurerm. A provider is a plugin that Terraform uses to create and manage your resources.
#provider "azurerm" {
#  features {} #  At least 1 "features" blocks are required. 
#}
