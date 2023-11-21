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
  }))
  default = [
    {
      name    = "default"
      vm_size = "Standard_DS2_v2"
    },
    {
      name    = "busy"
      vm_size = "Standard_DS2_v2"
    },
  ]
}

resource "azurerm_kubernetes_cluster" "example" {
  count               = 2
  name                = "${var.prefix}-k8s-${count.index + 1}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${var.prefix}-k8s-${count.index + 1}"

  dynamic "default_node_pool" {
    for_each = var.node_pools

    content {
      name       = default_node_pool.value.name
      vm_size    = default_node_pool.value.vm_size
      node_count = 1  # 最小节点数
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 5  # 最大节点数
    }
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"  # 指定的 Kubernetes 版本
}
