module "todo_rg" {
  source   = "../todo_infra/todo-rg"
  rg_name  = "todo-rg"
  location = "East US"
}

module "todo_vnet" {
  depends_on = [module.todo_rg]
  source     = "../todo_infra/todo-vnet"
  vnet_name  = "vnet1"
  rg_name    = "todo-rg"
  location   = "East US"
}
module "subnet1" {
  depends_on       = [module.todo_vnet]
  source           = "../todo_infra/todo-subnet"
  subnet_name      = "todo-subnet"
  rg_name          = "todo-rg"
  vnet_name        = "vnet1"
  address_prefixes = ["10.0.1.0/24"]
}

# module "key_vault_todo" {
#   source         = "../todo_infra/key_vault"
#   depends_on     = [module.todo_rg]
#   key_vault_name = "tijori0000"
#   rg_name        = "todo-rg"
#   location       = "East US"

# }

# module "username" {
#   source         = "../todo_infra/key_vault_secret"
#   depends_on     = [module.key_vault_todo]
#   secret_name    = "fe-username"
#   secret_value   = "adminuser"
#   rg_name        = "todo-rg"
#   key_vault_name = "tijori0000"
# }

# module "password" {
#   source         = "../todo_infra/key_vault_secret"
#   depends_on     = [module.key_vault_todo]
#   secret_name    = "fe-password"
#   secret_value   = "Shashank@1234"
#   rg_name        = "todo-rg"
#   key_vault_name = "tijori0000"
# }
module "pip_todo" {
  source     = "../todo_infra/public_ip"
  depends_on = [module.todo_rg]
  pip_name   = "todo_access_ip"
  rg_name    = "todo-rg"
  location   = "East US"
}

module "todo_vm" {
  depends_on           = [module.todo_rg, module.todo_vnet,module.subnet2]
  source               = "../todo_infra/todo-vm"
  nic_name             = "todo-nic_fe"
  rg_name              = "todo-rg"
  location             = "East US"
  vm_name              = "todo-fe-vm"
  vnet_name            = "vnet1"
  subnet_name          = "todo-subnet"
  username             = "adminuser"
  password             = "Shashank@1234"
  nsg_name = "nsg-fe"
  # key_vault_name       = "tijori0000"
}

module "subnet2" {
  depends_on       = [module.todo_vnet]
  source           = "../todo_infra/todo-subnet"
  subnet_name      = "AzureBastionSubnet"
  rg_name          = "todo-rg"
  vnet_name        = "vnet1"
  address_prefixes = ["10.0.2.0/24"]
}

module "pip_todo_be" {
  source     = "../todo_infra/public_ip"
  depends_on = [module.todo_rg]
  pip_name   = "todo_access_ip_be"
  rg_name    = "todo-rg"
  location   = "East US"
}

module "todo_vm_be" {
  depends_on           = [module.todo_rg, module.todo_vnet, module.subnet2]
  source               = "../todo_infra/todo-vm"
  nic_name             = "todo-nic_be"
  rg_name              = "todo-rg"
  location             = "East US"
  vm_name              = "todo-be-vm"
  vnet_name            = "vnet1"
  subnet_name          = "todo-subnet"
  username             = "adminuser"
  password             = "Shashank@1234"
  nsg_name           = "nsg-be"
  # key_vault_name       = "tijori0000"
}
# module "server" {
#   depends_on     = [module.todo_rg]
#   source         = "../todo_infra/server"
#   rg_name        = "todo-rg"
#   server_name    = "todo-sqlserver"
#   location       = "East US" 
# }
# module "database" {
#   depends_on  = [module.server]
#   source      = "../todo_infra/database"
#   rg_name     = "todo-rg"
#   server_name = "todo-sqlserver"
#   db_name     = "todo-db"
# }
module "loadbalancer" {
  depends_on = [module.pip_todo,module.todo_rg]
  source     = "../todo_infra/loadbalancer"
  rg_name    = "todo-rg"
  location   = "East US"
  pip_name   = "todo_access_ip"
}
module "bap_association_be" {
  depends_on = [module.todo_vm_be,module.loadbalancer]
  source     = "../todo_infra/bap_association"
  nic_name   = "todo-nic_be"
  rg_name    = "todo-rg"
}
module "bap_association_fe" {
  depends_on = [module.todo_vm,module.loadbalancer]
  source     = "../todo_infra/bap_association"
  nic_name   = "todo-nic_fe"
  rg_name    = "todo-rg"
}
module "pip_bastion" {
  source     = "../todo_infra/public_ip"
  depends_on = [module.todo_rg]
  pip_name   = "todo_bastion_ip"
  rg_name    = "todo-rg"
  location   = "East US"
}
module "azure_bastion" {
  depends_on   = [module.pip_todo,module.subnet2,module.todo_rg]
  source       = "../todo_infra/azure_basition"
  bastion_name = "todo-bastion"
  location     = "East US"
  rg_name      = "todo-rg"
  pip_name     = "todo_bastion_ip"
  subnet_name  = "AzureBastionSubnet"
  vnet_name    = "vnet1"
}

