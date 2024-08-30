provider "aws" {
  region = var.aws_region
}

module "vpc" {
    source = "/mnt/c/Users/a873907/Terraform-Code/Terraform/modules/vpc"
    vpc_vars = var.vpc_vars
    tags = var.tags
    
}

module "subnets" {
   source = "/mnt/c/Users/a873907/Terraform-Code/Terrafor/modules/subnets"  
   subnets = var.subnets
   tags = var.tags
   vpc_id   = module.vpc.vpc_id  
}