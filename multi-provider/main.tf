provider "aws" {
  region = "us-east-1"
  alias  = "aws_us"
}

provider "azurerm" {
  features {}
  alias           = "azure_east"
  subscription_id = "your-subscription-id"
  client_id       = "your-client-id"
  client_secret   = "your-client-secret"
  tenant_id       = "your-tenant-id"
}

########################
# AWS VPC
########################
resource "aws_vpc" "aws_main_vpc" {
  provider   = aws.aws_us
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "aws-vpc"
  }
}

########################
# Azure Virtual Network
########################
resource "azurerm_resource_group" "azure_rg" {
  provider = azurerm.azure_east
  name     = "azure-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "azure_vnet" {
  provider            = azurerm.azure_east
  name                = "azure-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.azure_rg.location
  resource_group_name = azurerm_resource_group.azure_rg.name
}
