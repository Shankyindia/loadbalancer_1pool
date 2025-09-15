resource "azurerm_virtual_network" "todo_vnet" {
    name = var.vnet_name
  resource_group_name = var.rg_name
  location = var.location
  address_space = ["10.0.0.0/16"]
}