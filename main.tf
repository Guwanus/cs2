terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws     = { source = "hashicorp/aws", version = ">= 5.0" }
    archive = { source = "hashicorp/archive", version = ">= 2.4.0" }
    random  = { source = "hashicorp/random", version = ">= 3.5.0" }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "guwan-state-bucket"
    key            = "cs2/terraform.tfstate"
    region         = "eu-central-1"
  }
}
