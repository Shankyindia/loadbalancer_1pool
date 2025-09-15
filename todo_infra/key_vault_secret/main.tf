data "azurerm_key_vault" "key_vault_todo" {
  name                = var.key_vault_name
  resource_group_name = var.rg_name
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = data.azurerm_key_vault.key_vault_todo.id
}