# terraform/main.tf

# Generate unique suffix for globally unique resources
resource "random_id" "unique" {
  byte_length = 4
}

# Local values for consistent naming
locals {
  unique_suffix   = random_id.unique.hex
  resource_prefix = "${var.project_name}-${var.environment}-${local.unique_suffix}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    CreatedDate = timestamp()
  })
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_prefix}"
  location = var.location

  tags = local.common_tags
}

# Storage Account for testing
resource "azurerm_storage_account" "main" {
  name                     = "st${replace(local.resource_prefix, "-", "")}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"

  # Security settings
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = var.environment == "prod" ? 30 : 7
    }
  }

  tags = local.common_tags
}