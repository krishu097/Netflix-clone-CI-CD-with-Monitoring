provider "aws" {
  region = var.aws_region
}

module "vpc" {
    source = "/mnt/c/Users/a873907/Terraform-Code/Terraform/modules/vpc"
    vpc_vars = var.vpc_vars
    tags = var.tags
    
}

module "subnets" {
   source = "/mnt/c/Users/a873907/Terraform-Code/Terraform/modules/subnets"  
   subnets = var.subnets
   tags = var.tags
   vpc_id   = module.vpc.vpc_id  
}

module "eks-sgs" {
   source = "/mnt/c/Users/a873907/Terraform-Code/Terraform/modules/sgs"  
   sgs = var.sgs
   tags = var.tags
   sg_rules = var.sg_rules
   vpc_id   = module.vpc.vpc_id 
}

module "eks-cluster" {
   source = "/mnt/c/Users/a873907/Terraform-Code/Terraform/modules/eks"
   eks-cluster             = var.eks-cluster
   vpc_id                  = module.vpc.vpc_id 
   security_group_ids      = values(module.eks-sgs.sgs_ids)
   subnet-pvt_ids          = values(module.subnets.private_subnets_ids)
   tags                    = var.tags
   addons                  = var.addons
   master-role-arn         = module.iam.master_role_arn
   node-role-arn           = module.iam.node_role_arn
   node-group              = var.node-group
   master_role_policies    = module.iam.master_role_policy_attachment
   node_role_policies      = module.iam.node_role_policies_attachment
}

module "iam" {
   source = "/mnt/c/Users/a873907/Terraform-Code/Terraform/modules/iam"
   master_role_policies = var.master_role_policies
   node_role_policies   = var.node_role_policies

}