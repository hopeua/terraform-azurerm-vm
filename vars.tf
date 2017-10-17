variable "admin" {
  description = "Default user with root access"
  type = "map"
  default = {
    name = "terraform"
    public_key = ""
  }
}

variable "namespace" {
  description = "Prefix for resource names"
}
variable "name" {
  description = "Name of the service"
}
variable "location" {
  description = "Resource location. To see full list run 'az account list-locations'"
}
variable "cidr" {
  default = "10.0.0.0/16"
}
variable "subnet" {
  default = "10.0.1.0/24"
}
variable "vm_size" {
  description = "Size of the vm. To see full list run 'az vm list-sizes'"
}
variable "vm_disk_type" {
  description = "Storage class. Can be Standard_LRS or Premium_LRS"
  default = "Standard_LRS"
}
variable "os" {
  description = "Disk image with preinstalled OS"
  type = "map"
  default = {
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.4"
    version = "latest"
  }
}
