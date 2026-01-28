terraform {
  required_providers {
    # We will be working with linode and so will need the linode provider
    # in order to update DNS on linode, we'll need the linode provider.
    linode = {
      source  = "linode/linode"
    }
  }
  backend "s3" {
      bucket                      = "asiwko-terraform-state"
      key                         = "tf/tfstate"  
      region                      = "us-east-1"
      # region                      = "us-iad" # gemini recommended east1 for signing
      use_path_style              = true
      skip_region_validation      = true  
      skip_credentials_validation = true
      skip_requesting_account_id  = true
      skip_s3_checksum            = true
      skip_metadata_api_check     = true
      sts_region                  = "us-east-1"      
      endpoints                   = {
                                    s3 = "https://us-iad-10.linodeobjects.com"
                                  }
  }
}

provider "azurerm" {
  features {}
}
variable "LINODE_API_KEY" {
  description = "The key to the Linode API"
  type        = string
}

provider "linode" {
  token = var.LINODE_API_KEY
}

