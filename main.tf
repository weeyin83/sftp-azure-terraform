##
# Terraform Configuration
##

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1, < 4.0.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.2.0, < 3.0.0"
    }
  }
} 

provider "azapi" {
  # Configuration options
}

provider "azurerm" {
  features {}
  subscription_id = "xxxx-xxxx-xxxx-xxxxx" #Update with your Azure subscription ID
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = module.naming.resource_group.name_unique

  tags = {
    Environment = var.tag_environment
    Project     = var.tag_project
    Creator     = var.tag_creator
  }
}


# Storage Account (Premium Block Blob, HNS enabled, SFTP enabled)
resource "azurerm_storage_account" "sa" {
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location

  # premium block blob performance / required for SFTP
  account_tier             = "Premium"
  account_replication_type = var.account_replication_type
  account_kind             = "BlockBlobStorage"   # Premium Block Blob

  # Enable hierarchical namespace (ADLS Gen2) - required for SFTP
  is_hns_enabled = true

  # Enable SFTP support on the storage account
  # attribute name may appear in providers as `sftp_enabled` or `is_sftp_enabled`;
  # the azurerm provider supports `sftp_enabled` in modern releases.
  sftp_enabled = true

  # security defaults for demo: enforce https only
  allow_nested_items_to_be_public = false
}

# Blob container (this will act as the folder / home-root)
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

# Local user for SFTP (SSH public-key auth). 
# Note: attribute names for this resource are provider-dependent. Modern azurerm provides `azurerm_storage_account_local_user`.
resource "azurerm_storage_account_local_user" "sftp_user" {
  name                = var.sftp_local_user
  storage_account_id  = azurerm_storage_account.sa.id
  home_directory      = "/"

  # Enable password authentication instead of SSH key
  ssh_key_enabled      = false
  ssh_password_enabled = true

  # Remove or comment out the ssh_authorized_key block since we're using password auth
  # ssh_authorized_key {
  #   key = tls_private_key.sftp_key.public_key_openssh
  # }

  # Example: grant access to the container with read/write/list/create
  permission_scope {
    resource_name = azurerm_storage_container.container.name
    service       = "blob"

    permissions {
      read    = true
      write   = true
      delete  = true
      list    = true
      create  = true
    }
  }
}
