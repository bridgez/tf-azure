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


variable "admin_password" {
  description = "admin_password"
}
variable "azurerm_resource_group" {
  description = "resource group"
  default = "Terraform1106"
}

# The provider block configures the specified provider, in this case azurerm. A provider is a plugin that Terraform uses to create and manage your resources.
#provider "azurerm" {
#  features {} #  At least 1 "features" blocks are required. 
#}

# Use resource blocks to define components of your infrastructure. 
# avoid the same name, or terraform state list and terraform state rm is needed

# resource "azurerm_resource_group" "resourceGroup" {
#   location = var.location # "East Asia"
#   name     = var.rgname
# }

# resource "azurerm_resource_group" "newResourceGroup" {
#   location = var.location
#   name     = "Terraform_Test1"
#   tags = { # from here three lines are added.
#     Environment = "Terraform Getting Started"
#     Team        = "DevOps"
#   }
# }






# following is aks
# resource "azurerm_kubernetes_cluster" "aks_cluster" {
#   name                = "aks27"
#   location            = azurerm_resource_group.aks_rg.location
#   resource_group_name = azurerm_resource_group.aks_rg.name
#   dns_prefix          = "myakscluster"  # DNS prefix for AKS cluster URL

#   default_node_pool {
#     name       = "agentpool" # default
#     node_count = 1
#     vm_size    = "Standard_B2s"  # Change this to your preferred VM size
#   }
#   service_principal {
#     client_id     = "e59cceec-5706-420f-adea-4d0d3e239989" # YOUR_AZURE_CLIENT_ID
#     client_secret = "IE68Q~UFFRmT9kjyWgUTUvTxi5SDnp2Qx_XA3c6d" # YOUR_AZURE_CLIENT_SECRET
#   }
#   tags = {
#     environment = "dev"
#   }
# }
