terraform {
  required_providers {
    # We will be working with linode and so will need the linode provider
    # in order to update DNS on linode, we'll need the linode provider.
    linode = {
      source = "linode/linode"
    }
  }

  backend "local" {
    path = "/container_shared/tfstate/linode.tfstate"
  }

  # This project started with the state stored in the provider's oject storage.  
  # I moved it to local storage as providers charge for object storage and there was no benefit once the exercise was complete.
  # backend "s3" {
  #   bucket = "asiwko-terraform-state"
  #   key    = "tf/tfstate"
  #   region = "us-iad-1"
  #   endpoints = {
  #     s3 = "https://us-iad-10.linodeobjects.com"
  #   }

  #   use_path_style              = true
  #   skip_credentials_validation = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  #   skip_s3_checksum            = true

  # }
}
provider "azurerm" {
  features {}
}

provider "linode" {
  token = var.LINODE_API_KEY
}

