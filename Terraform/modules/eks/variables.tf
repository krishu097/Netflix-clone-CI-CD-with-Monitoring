variable "eks-cluster" {
  type = map(
    object (
        {
           cluster-name = string
           cluster-version = number
           endpoint-private-access = bool
           endpoint-public-access = bool
        }
    )

 )
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" { }

variable "subnet-pvt_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}

variable "addons" {
      type = map(object(
        {
           name     = string
           version  = string 
      }
    )
  )
}
variable "master-role-arn" {}

variable "node-role-arn" {}

variable "node-group" {
  type = map(
    object(
        {
            name             = string
            desired_capacity = number
            min_capacity     = number
            max_capacity     = number
            instance_types   = list(string)
        }
       )
    )
}

variable "master_role_policies" {
  description = "IAM role policy attachment for the master role"
  type        = any
}
variable "node_role_policies" {
  description = "IAM role policy attachment for the node role"
  type        = any
}