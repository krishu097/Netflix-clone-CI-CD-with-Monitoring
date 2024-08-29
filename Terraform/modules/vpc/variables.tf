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


variable "sub-tags" {
  type = map(string)
}

