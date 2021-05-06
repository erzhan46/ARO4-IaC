variable "subscription" {}

variable "aro_name" {
  description 		= "The Azure Red Hat OpenShift 4.x (ARO) name"
}

variable "aro_vnet_resource_group_name" {
  description 		= "Name of resource group to deploy ARO VNET/Subnets in."
}

variable "aro_location" {
  description 		= "The ARO location where all resources should be created"
}

variable "tags" {
  description 		= "Tags to apply to all resources created."
  type        		= map(string)
  default     		= {
    Environment 	= "Production"
  }
}


variable "aro_sp_app_id" {
  description       = "The Service Provider App ID used by the Azure Red Hat OpenShift"
}

variable "aro_sp_password" {
  description       = "The Service Provider Password used by the Azure Red Hat OpenShift"
}

variable "aro_sp_object_id" {
  description       = "The Service Provider Object ID used by the Azure Red Hat OpenShift"
}

variable "aro_rp_object_id" {
  description       = "The Resource Provider Object ID used by the Azure Red Hat OpenShift"
}


variable "aro_vnet_name" {
  description       = "The name for ARO Virtual Network"
}

variable "aro_vnet_cidr" {
  description       = "The IP Range assigned to the ARO VNET"
}

variable "aro_master_subnet_name" {
  description       = "The Name assigned to the ARO Masters' Subnet"
}

variable "aro_master_subnet_cidr" {
  description       = "The IP Range assigned to the ARO Masters' Subnet"
}

variable "aro_worker_subnet_name" {
  description       = "The Name assigned to the ARO Workers' Subnet"
}

variable "aro_worker_subnet_cidr" {
  description       = "The IP Range assigned to the ARO Workers' Subnet"
}

variable "service_endpoints" {
  type          = list
  description       = ""
  default       = [
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

variable "aro_api_server_visibility" {
  description       = "Cluster API and Console visibility. Values are Public/Private"
}

variable "aro_ingress_visibility" {
  description       = "API ingress visibility. Values are Public/Private"
}

variable "aro_worker_node_size" {
  description       = "The ARO Worker nodes size, Default set to Standard_D4s_v3"
}

variable "aro_worker_node_count" {
  type              = number
  default           = 3
  description       = "The ARO Worker nodes count (Default is 3)"
}

variable "aro_worker_node_disk_size" {
  type              = number
  default           = 128
  description       = "The ARO Worker nodes Disk Size in GigaBytes (Default is 128Gb)"
}


variable "akv_name" {
  description       = "Name of Azure Key Vault holding the pull-secret for Cluster Manager"
}

variable "akv_key_name" {
  description       = "Name of Azure Key holding the pull-secret for Cluster Manager"
}

variable "akv_key_value" {
  description       = "Azure Key Value holding the pull-secret for Cluster Manager"
}

variable "roles" {
  description       = "Roles to be assigned to the Principal"
  type          = list(object({ role = string}))
  default       = []
}



