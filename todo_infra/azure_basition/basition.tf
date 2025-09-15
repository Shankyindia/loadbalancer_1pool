data "azurerm_public_ip" "pip_bastion" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}
data "azurerm_subnet" "subnet2" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.subnet2.id
    public_ip_address_id = data.azurerm_public_ip.pip_bastion.id
  }
}