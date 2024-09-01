
vpc_vars = {
  name       = "eks-vpc"
  cidr       = "10.0.0.0/16"
  tenancy    = "default"
  dnssupport = "true"
  hostnames  = "true"
}
tags = {
  app = "EKS"
  env = "Test"
  owner = "Krishna"
}


#########################################################
subnets = {
  "public-subnet-1" = {
    availability_zone               = "us-east-1a"
    cidr_block                      = "10.0.1.0/24"
    map_public_ip_on_launch         = true
    assign_ipv6_address_on_creation = false
    name                            = "public-subnet-1"
  },
  "public-subnet-2" = {
    availability_zone               = "us-east-1b"
    cidr_block                      = "10.0.2.0/24"
    map_public_ip_on_launch         = true
    assign_ipv6_address_on_creation = false
    name                            = "public-subnet-2"
  },
  "public-subnet-3" = {
    availability_zone               = "us-east-1c"
    cidr_block                      = "10.0.3.0/24"
    map_public_ip_on_launch         = true
    assign_ipv6_address_on_creation = false
    name                            = "public-subnet-3"
  },


  "private-subnet-1" = {
    availability_zone               = "us-west-1a"
    cidr_block                      = "10.0.4.0/24"
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false
    name                            = "private-subnet-1"
  },
  "private-subnet-2" = {
    availability_zone               = "us-west-1a"
    cidr_block                      = "10.0.5.0/24"
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false
    name                            = "private-subnet-2"
  }

}
###########################################################

sgs = {

  "eks-security-group" = {
    name = "eks-sg"
    description = "EKS Cluster Communication Inbound rules"
  }
}

sg_rules = {
  "ssh-access"    = {
    cidr_blocks   = "0.0.0.0/0"
    from_port     = "22"
    protocol      = "ssh"
    to_port       = "22"
    description = "SSH access"
  },
  "http-access"    = {
    cidr_blocks   = "0.0.0.0/0"
    from_port     = "80"
    protocol      = "tcp"
    to_port       = "80"
    description = "HTTP access"
  },
  "https-access"    = {
    cidr_blocks   = "0.0.0.0/0"
    from_port     = "443"
    protocol      = "tcp"
    to_port       = "443"
    description = "HTTPS access"
  }
}