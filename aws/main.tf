terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"

    }
  }

  backend "s3" {
    bucket       = "devops-wiki-tf-state-bucket--1b99490b6410aaaf"
    key          = "state/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
    profile      = "lync"
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "lync"
}

# networking module
module "networking" {
  source = "./networking"
}

# security group module
module "security_group" {
  source = "./security"
  vpc_id = module.networking.vpc_id
}

# compute module
module "compute" {
  source               = "./compute"
  subnet_ids           = module.networking.subnet_ids
  fe_security_group_id = module.security_group.fe_security_group_id
  be_security_group_id = module.security_group.be_security_group_id
  yaw_public_key       = var.yaw_public_key
  github_token         = var.github_token
  postgres_user        = var.postgres_user
  postgres_password    = var.postgres_password
  dockerhub_username   = var.dockerhub_username
  dockerhub_password   = var.dockerhub_password
}

# dns module
module "dns" {
  source = "./dns"
  fe_eip = module.compute.fe_eip
}
