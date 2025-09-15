resource "azurerm_resource_group" "todo_rg" {
  name     = var.rg_name
  location = var.location
}