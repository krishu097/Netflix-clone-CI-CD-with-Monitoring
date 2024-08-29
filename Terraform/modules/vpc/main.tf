resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_vars["cidr"]
  instance_tenancy                 = var.vpc_vars["tenancy"]
  enable_dns_support               = var.vpc_vars["dnssupport"]
  enable_dns_hostnames             = var.vpc_vars["hostnames"]
  
  tags = {
    Name        = var.vpc_vars["name"]
    Application = var.tags["app"]
    Environment = var.tags["env"]
    Owner       = var.tags["owner"]
    Terraform   = var.tags["terraform"]
  }

}

resource "aws_subnet" "subnets" {
  for_each = var.subnets
  vpc_id   = aws_vpc.main.id   

  availability_zone               = each.value.availability_zone
  cidr_block                      = each.value.cidr_block
  map_public_ip_on_launch         = each.value.map_public_ip_on_launch
  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation

  tags = {
    Name        = each.value.name
    Application = var.sub-tags["app"]
    EOTP        = var.sub-tags["eotp"]
    Environment = var.sub-tags["env"]
    Owner       = var.sub-tags["owner"]
    Terraform   = var.sub-tags["terraform"]
  }
}




# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id 

  tags = merge(
    {
      Name = "eks-igw"
    }
  )
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain   = "vpc"

  tags = merge(
    {
      Name = "eks-nat-eip"
    }
  )
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet[1]

  tags = merge(
    {
      Name = "eks-nat"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}