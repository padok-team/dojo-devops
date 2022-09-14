terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }

    curl = {
      source  = "anschoewe/curl"
      version = "1.0.2"
    }
  }
}

provider "aws" {
  region = local.context.region

  default_tags {
    tags = {
      Env         = local.context.env
      Region      = local.context.region
      OwnedBy     = "Dojo Padok - ${local.context.owner}"
      ManagedByTF = true
    }
  }
}

provider "curl" {
}

data "aws_caller_identity" "current" {}
