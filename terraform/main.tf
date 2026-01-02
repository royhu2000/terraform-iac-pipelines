# main.tf
module "web_app_dev" {
  source = "./modules/web-application"

  name                = "myapp-dev"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  sku_name           = "B1"

  tags = {
    Environment = "development"
    Project     = "my-project"
  }
}

module "web_app_prod" {
  source = "./modules/web-application"

  name                = "myapp-prod"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  sku_name           = "P2v2"

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}