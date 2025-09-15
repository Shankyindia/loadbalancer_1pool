data "azurerm_public_ip" "pip_todo" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}

resource "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = data.azurerm_public_ip.pip_todo.id
  }
}
resource "azurerm_lb_backend_address_pool" "lb_bap" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "ssh-running-probe"
  port            = 80
}
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.lb_bap.id]
  frontend_ip_configuration_name = "PublicIPAddress"
}