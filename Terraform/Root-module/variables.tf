variable "aws_region" {
    type = string
    default = "us-east-1"
  
}

variable "vpc_vars" {
  type = map(string)
}

variable "tags" {
  type = map(string)
}

variable "subnets" {
  type = map(
    object(
      {
        availability_zone               = string
        cidr_block                      = string
        map_public_ip_on_launch         = bool
        assign_ipv6_address_on_creation = bool
        name                            = string
      }
    )
  )
}
##############################################

variable "sgs" {
  type = map(
    object(
      {
        name        = string
        description = string
      }
    )
  )
}

variable "sg_rules" {
  type = map(
    object(
      {
       cidr_blocks = string
        from_port   = number
        protocol    = string 
        to_port     = number
        description = string
      
      }
   )
  )
}

###########################################
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

variable "addons" {
  type = map(
    object(
      {
         name     = string
         version  = string 
      }
    )
  )
}
####################################################
variable "master_role_policies" {
  type = map(
    object(
      {
         policy_arn = string
         
      }
    )
  )
}

variable "node_role_policies" {
  type = map(
    object(
      {
         policy_arn = string
         
      }
    )
  )  
}
