terraform {
  required_version 	= ">= 0.12.0"
}

provider "azurerm" {
  subscription_id 	= var.subscription
  version		= ">= 2.17"
  features 		{}
}

data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "aro_vnet_resource_group" {
  name     		= var.aro_vnet_resource_group_name
  location 		= var.aro_location

  tags			= var.tags
}

resource "azurerm_key_vault" "akv" {
  name                  = var.akv_name
  resource_group_name   = var.aro_vnet_resource_group_name
  location 		        = var.aro_location
  tenant_id             = data.azurerm_client_config.current.tenant_id
  sku_name              = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
      "list"
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover",
      "list"
    ]
  }
}

resource "azurerm_key_vault_secret" "pull-secret" {
  name              = var.akv_key_name
  value             = var.akv_key_value
  key_vault_id      = azurerm_key_vault.akv.id
}


resource "azurerm_virtual_network" "aro_vnet" {
  name                  = var.aro_vnet_name
  resource_group_name   = azurerm_resource_group.aro_vnet_resource_group.name
  location              = azurerm_resource_group.aro_vnet_resource_group.location
  address_space         = [var.aro_vnet_cidr]
}

resource "azurerm_subnet" "aro_master_subnet" {
  name                  = var.aro_master_subnet_name
  virtual_network_name  = azurerm_virtual_network.aro_vnet.name
  resource_group_name   = azurerm_resource_group.aro_vnet_resource_group.name
  address_prefixes  = [var.aro_master_subnet_cidr]

  enforce_private_link_service_network_policies = true

  service_endpoints     = var.service_endpoints
}

resource "azurerm_subnet" "aro_worker_subnet" {
  name                  = var.aro_worker_subnet_name
  virtual_network_name  = azurerm_virtual_network.aro_vnet.name
  resource_group_name   = azurerm_resource_group.aro_vnet_resource_group.name
  address_prefixes  = [var.aro_worker_subnet_cidr]

  service_endpoints     = var.service_endpoints
}


resource "azurerm_template_deployment" "azure-arocluster" {
  name          = var.aro_name
  resource_group_name   = var.aro_vnet_resource_group_name

  template_body = file("${path.module}/Microsoft.AzureRedHatOpenShift.json")

  parameters        = {
    clusterName         = var.aro_name
    location            = var.aro_location
    clusterResourceGroupName    = join("-", [var.aro_vnet_resource_group_name, "MANAGED"])

    tags            = jsonencode(var.tags)

    apiServerVisibility     = var.aro_api_server_visibility
    ingressVisibility       = var.aro_ingress_visibility

    aadClientId         = var.aro_client_id
    aadClientSecret     = var.aro_client_secret

    clusterVnetId       = azurerm_virtual_network.aro_vnet.id
    workerSubnetId      = azurerm_subnet.aro_worker_subnet.id
    masterSubnetId      = azurerm_subnet.aro_master_subnet.id

    workerCount         = var.aro_worker_node_count
    workerVmSize        = var.aro_worker_node_size

    pullsecret          = azurerm_key_vault_secret.pull-secret.value
  }

  deployment_mode   = "Incremental"

  timeouts {
    create = "90m"
  }

}

