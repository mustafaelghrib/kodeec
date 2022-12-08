#Azure Virtual Machines

variable "machine_name" { type = string }
variable "machine_username" { type = string }
variable "machine_size" { type = string }
variable "machine_os_caching" { type = string }
variable "machine_os_storage_account_type" { type = string }
variable "machine_image_publisher" { type = string }
variable "machine_image_offer" { type = string }
variable "machine_image_sku" { type = string }
variable "machine_image_version" { type = string }
variable "machine_ssh_public_key" { type = string }
variable "machine_ssh_private_key" { type = string }
variable "machine_scripts" { type = list(string) }

resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.machine_name
  computer_name                   = var.machine_name
  admin_username                  = var.machine_username
  size                            = var.machine_size
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  network_interface_ids           = [azurerm_network_interface.main.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.machine_username
    public_key = var.machine_ssh_public_key
  }

  os_disk {
    caching              = var.machine_os_caching
    storage_account_type = var.machine_os_storage_account_type
  }

  source_image_reference {
    publisher = var.machine_image_publisher
    offer     = var.machine_image_offer
    sku       = var.machine_image_sku
    version   = var.machine_image_version
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.machine_username
      host        = self.public_ip_address
      private_key = var.machine_ssh_private_key
    }
    scripts = var.machine_scripts
  }

}

output "MACHINE_PUBLIC_IP" {
  value = azurerm_linux_virtual_machine.main.public_ip_address
}

output "MACHINE_SSH_CONNECT" {
  value = "ssh ${var.machine_username}@${azurerm_linux_virtual_machine.main.public_ip_address}"
}
