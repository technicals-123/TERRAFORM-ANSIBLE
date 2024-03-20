
resource "azurerm_network_interface" "demonetworkinterface" {
  name                = "demonic"
  location            = azurerm_resource_group.demoresourcegroup.location
  resource_group_name = azurerm_resource_group.demoresourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demosubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demopublicip.id
  }
}

resource "azurerm_linux_virtual_machine" "demolinuxvm" {
  name                            = "demolinuxmachine"
  resource_group_name             = azurerm_resource_group.demoresourcegroup.name
  location                        = azurerm_resource_group.demoresourcegroup.location
  size                            = "Standard_D2_V2"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.demonetworkinterface.id,
  ]

  //admin_ssh_key {
  //username   = "trainer"
  //public_key = "${file("/home/pk/.ssh/id_rsa.pub")}"
  //}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install software-properties-common -y",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get install ansible -y"
    ]

    connection {
      type     = "ssh"
      user     = var.username
      password = var.password
      // Add your SSH private key or password authentication here
      //private_key = file("${path.module}/path/to/your/private/key.pem")
      //agent = false
      port = 22
      host = azurerm_public_ip.demopublicip.ip_address
    }
  }


}
resource "null_resource" "run_ansible_playbook" {
  # This triggers the provisioner after the remote exec is done
  depends_on = [azurerm_linux_virtual_machine.demolinuxvm]

  # Use local-exec to run Ansible locally
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${azurerm_public_ip.demopublicip.ip_address},' nginx.yml --extra-vars='ansible_ssh_user=trainer' --extra-vars='ansible_ssh_pass=Godisgreat01' --become --become-user=root"
  }
}


