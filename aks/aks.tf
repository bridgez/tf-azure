provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "example" {
  count               = 2  # 可以根据需要更改集群数量
  name                = "${var.prefix}-k8s-${count.index + 1}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${var.prefix}-k8s-${count.index + 1}"

  tags = {
    env = "cdt"
    # 其他标签键值对
  }

  dynamic "node_pool" {
    for_each = var.node_pools

    content {
      name       = node_pool.key
      node_count = node_pool.value["node_count"]
      vm_size    = node_pool.value["vm_size"]
    }
  }

  identity {
    type = "SystemAssigned"
  }
  kubernetes_version = "1.27.7"  # 指定的 Kubernetes 版本
}

variable "node_pools" {
  type = map(object({
    node_count = number
    vm_size    = string
  }))
  default = {
    default = {
      node_count = 1
      vm_size    = "Standard_DS2_v2"
    },
    # 可以根据需要添加其他节点池
    busy = {
      node_count = 5
      vm_size    = "Standard_DS2_v2"
    }
  }
}
