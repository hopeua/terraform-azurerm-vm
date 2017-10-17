# Resource group
resource "azurerm_resource_group" "default" {
  name = "${var.namespace}-${var.name}"
  location = "${var.location}"
}

# Public IP
resource "azurerm_public_ip" "default" {
  name = "${var.namespace}-${var.name}-PublicIP"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  public_ip_address_allocation = "static"
}

# Network security rules
resource "azurerm_network_security_group" "default" {
  name = "${var.namespace}-${var.name}-SecurityGroup"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
}

resource "azurerm_network_security_rule" "ssh" {
  name = "ssh"
  priority = 1000
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = 22
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = "${azurerm_resource_group.default.name}"
  network_security_group_name = "${azurerm_network_security_group.default.name}"
}

# Virtual network
resource "azurerm_virtual_network" "default" {
  name = "${var.namespace}-${var.name}-VirtualNetwork"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  address_space = ["${var.cidr}"]
}

resource "azurerm_subnet" "default" {
  name = "${var.namespace}-${var.name}-PrivateSubnet"
  resource_group_name = "${azurerm_resource_group.default.name}"
  virtual_network_name = "${azurerm_virtual_network.default.name}"
  address_prefix = "${var.subnet}"
}

# Network interface
resource "azurerm_network_interface" "default" {
  name = "${var.namespace}-${var.name}-NetworkInterface"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  network_security_group_id = "${azurerm_network_security_group.default.id}"

  ip_configuration {
    name = "${var.namespace}-${var.name}-SubnetIPConfig"
    subnet_id = "${azurerm_subnet.default.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.default.id}"
  }
}

# Virtual machine
resource "azurerm_virtual_machine" "default" {
  name = "${var.namespace}-${var.name}-VM"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  network_interface_ids = ["${azurerm_network_interface.default.id}"]
  vm_size = "${var.vm_size}"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "${var.os["publisher"]}"
    offer = "${var.os["offer"]}"
    sku = "${var.os["sku"]}"
    version = "${var.os["version"]}"
  }

  storage_os_disk {
    name = "${var.namespace}-${var.name}-VM-OS"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "${var.vm_disk_type}"
  }

  os_profile {
    computer_name = "${var.name}"
    admin_username = "${var.admin["name"]}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys = {
      path = "/home/${var.admin["name"]}/.ssh/authorized_keys"
      key_data = "${var.admin["public_key"]}"
    }
  }
}
