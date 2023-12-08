provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name                 = "default"
    node_count           = 1
    enable_auto_scaling = true
    min_count          = 1
    max_count          = 3
    vm_size              = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.27.7"  # 指定的 Kubernetes 版本
}
