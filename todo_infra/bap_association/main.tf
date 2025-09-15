data "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = var.rg_name
}
data "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  resource_group_name = var.rg_name
}

data "azurerm_lb_backend_address_pool" "lb_bap" {
  name            = "BackEndAddressPool"
  loadbalancer_id = data.azurerm_lb.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "bap_association" {
  network_interface_id    = data.azurerm_network_interface.nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.lb_bap.id
}