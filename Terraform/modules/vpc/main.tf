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

  tags = (
    {
      Name = "eks-igw"
    }
  )
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain   = "vpc"

  tags = (
    {
      Name = "eks-nat-eip"
    }
  )
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet[1]

  tags = (
    {
      Name = "eks-nat"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "route-pub" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  

  tags = {
    Name        = var.route_vars["route-pub_name"]
    Application = var.tags["app"]
    Environment = var.tags["env"]
    Owner       = var.tags["owner"]
    Terraform   = var.tags["terraform"]
  }
}

resource "aws_route_table" "route-priv" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    
  }

  tags = {
    Name        = var.route_vars["route-priv_name"]
    Comments    = var.route_vars["route-priv_description"]
    Application = var.tags["app"]
    EOTP        = var.tags["eotp"]
    Environment = var.tags["env"]
    Owner       = var.tags["owner"]
    Terraform   = var.tags["terraform"]
  }
}

# Create Private Route Tables
resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    {
      Name = format("${var.name}-private-%s", count.index + 1)
    },
    var.tags
  )
}
# Associate Private Route Tables with Private Subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(var.private_subnets, count.index)
  route_table_id = aws_route_table.private[count.index].id
}


resource "aws_route_table_association" "pub_a" {
  subnet_id      = var.subnets_ids[""]
  route_table_id = aws_route_table.route-pub.id
}

resource "aws_route_table_association" "priv_a" {
  subnet_id      = var.subnets_ids[""]
  route_table_id = aws_route_table.route-priv.id
}

resource "aws_route_table_association" "pub_b" {
  subnet_id      = var.subnets_ids[""]
  route_table_id = aws_route_table.route-pub.id
}

resource "aws_route_table_association" "priv_b" {
  subnet_id      = var.subnets_ids[""]
  route_table_id = aws_route_table.route-priv.id
}





