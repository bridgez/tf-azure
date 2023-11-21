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
    },
    {
      name       = "advanced"
      vm_size    = "Standard_DS3_v2"  # 更高级别的 vm_size
      node_count = 1
    },
  ]
}

resource "azurerm_kubernetes_cluster" "example" {
  count               = 2
  name                = "${var.prefix}-k8s-${count.index + 1}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${var.prefix}-k8s-${count.index + 1}"

  dynamic "node_pool" {
    for_each = var.node_pools

    content {
      name       = node_pool.value.name
      vm_size    = node_pool.value.vm_size
      node_count = node_pool.value.node_count
    }
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"  # 指定的 Kubernetes 版本
}
