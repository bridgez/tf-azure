provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

variable "node_pools" {
  type = list(object({
    name       = string
    vm_size    = string
    node_count = number
  }))
  default = [
    {
      name       = "default"
      vm_size    = "Standard_DS2_v2"
      node_count = 1
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3  # 最大节点数
    },
    {
      name       = "advanced"
      vm_size    = "Standard_DS3_v2"  # 更高级别的 vm_size
      node_count = 1
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3  # 最大节点数
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
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"  # 指定的 Kubernetes 版本
}
