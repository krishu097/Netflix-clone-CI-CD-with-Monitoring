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
