provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

variable "node_pools" {
  type = map(object({
    vm_size             = string
    node_count          = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
  }))
  default = {
    default = {
      vm_size             = "Standard_DS2_v2"
      node_count          = 1
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3
    }
    advanced = {
      vm_size             = "Standard_DS3_v2"
      node_count          = 1
      enable_auto_scaling = false  # 手动伸缩
      min_count           = 1
      max_count           = 3
    }
  }
}

resource "azurerm_kubernetes_cluster" "example" {
  for_each            = var.node_pools
  name                = "${var.prefix}-k8s-${each.key}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${var.prefix}-k8s-${each.key}"

  dynamic "node_pool" {
    for_each = [1]  # 固定值 [1] 表示每个节点池都会被创建
    content {
      name       = each.key
      vm_size    = each.value.vm_size
      node_count = each.value.node_count

      enable_auto_scaling = each.value.enable_auto_scaling
      min_count           = each.value.min_count
      max_count           = each.value.max_count
    }
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"
}
