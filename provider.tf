terraform {
  required_providers {
    # Specify your provider here
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
    # Add other providers if needed
  }
}

provider_installation {
  # Skip provider registration
  skip_provider_registration = true
}

provider "azurerm" {
  features {}
}
