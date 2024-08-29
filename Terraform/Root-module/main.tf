provider "aws" {
  region = var.aws_region
}

module "vpc" {
    source = "/mnt/c/Users/a873907/Terraform-Code/Terraform/modules/vpc"
    

}