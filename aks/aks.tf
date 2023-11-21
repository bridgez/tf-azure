provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

variable "node_pools" {
  type = list(object({
    name                = string
    node_count          = number
    vm_size             = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
  }))
  default = [
    {
      name                = "default"
      node_count          = 1
      vm_size             = "Standard_DS2_v2"
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 5
    },
    {
      name       = "busy"
      node_count = 2
      vm_size    = "Standard_DS2_v2"
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 5
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
    node_count = var.node_pools[count.index].node_count
    vm_size    = var.node_pools[count.index].vm_size

    enable_auto_scaling = var.node_pools[count.index].enable_auto_scaling
    min_count           = var.node_pools[count.index].min_count
    max_count           = var.node_pools[count.index].max_count
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"  # 指定的 Kubernetes 版本
}
