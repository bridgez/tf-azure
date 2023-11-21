provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

variable "node_pools" {
  type = list(object({
    name              = string
    vm_size           = string
    node_count        = number
    enable_auto_scaling  = bool
    min_count         = number
    max_count         = number
  }))
  default = [
    {
      name               = "default"
      vm_size            = "Standard_DS2_v2"
      node_count         = 1
      enable_auto_scaling = true
      min_count          = 1
      max_count          = 3
    },
    {
      name               = "advanced"
      vm_size            = "Standard_DS3_v2"
      node_count         = 1
      enable_auto_scaling = false
      min_count          = 1
      max_count          = 3
    },
  ]
}

resource "azurerm_kubernetes_cluster" "example" {
  count               = length(var.node_pools)
  name                = "${var.prefix}-k8s-${count.index + 1}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${var.prefix}-k8s-${count.index + 1}"

  default_node_pool {
    name       = var.node_pools[count.index].name
    vm_size    = var.node_pools[count.index].vm_size
    node_count = var.node_pools[count.index].node_count

    enable_auto_scaling = var.node_pools[count.index].enable_auto_scaling
    min_count          = var.node_pools[count.index].min_count
    max_count          = var.node_pools[count.index].max_count
  }

  advanced_node_pool {
    name       = "advanced"
    vm_size    = "Standard_DS3_v2"
    node_count = 1
    enable_auto_scaling = false
    min_count          = 1
    max_count          = 3
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"
}
