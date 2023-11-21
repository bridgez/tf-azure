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

  default_node_pool {
    name       = var.node_pools[count.index].name
    vm_size    = var.node_pools[count.index].vm_size
    node_count = 1  # 最小节点数
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 5  # 最大节点数
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"  # 指定的 Kubernetes 版本
}
