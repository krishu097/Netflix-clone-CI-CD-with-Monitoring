##############SUBNETS###################
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

variable "tags" {
  type = map(string)
}

variable "vpc_id" { }