# modules/web-application/variables.tf
variable "name" {
  description = "Name of the web application"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku_name" {
  description = "App Service Plan SKU"
  type        = string
  default     = "B1"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# modules/web-application/main.tf
resource "azurerm_service_plan" "main" {
  name                = "plan-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id
  tags                = var.tags

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}

# modules/web-application/outputs.tf
output "web_app_name" {
  description = "Name of the web application"
  value       = azurerm_linux_web_app.main.name
}

output "web_app_url" {
  description = "URL of the web application"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.main.id
}