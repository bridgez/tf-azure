# from official website: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine


# for label use
variable "prefix" {
  default = "tf-1102"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["192.168.0.0/16"]
  location            = var.location
  resource_group_name = var.rgname # azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "internal" {
  name                 = "subnet-eastasia-001"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/24"] #      = "192.168.0.0/24"
}

# Create public IP, which you can search public ip on the search bar
resource "azurerm_public_ip" "publicip" {
  name                = "pip-eastasia-001"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Static"
}

# Create network security group and rule, network security groups
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-sshallow-001"
  location            = var.location
  resource_group_name = var.rgname

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.rgname
  #network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "niccfg-vmterraform"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

#resource "azurerm_ssh_public_key" "example" {
#  name                = "example"
#  resource_group_name = var.rgname
#  location            = var.location
#  public_key          = file("~/.ssh/id_rsa.pub")
#}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = var.rgname
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "22.04.202301100" # "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "bridgez"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
# depends_on = [azurerm_resource_group.azurerm_resource_group]  # 定义虚拟机依赖于资源组
# depends_on = [azurerm_resource_group.example]  # 定义虚拟机依赖于资源组
}
