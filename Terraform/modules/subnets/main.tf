##############SUBNETS###################

resource "aws_subnet" "subnets" {
  for_each = var.subnets
  vpc_id   = var.vpc_id   

  availability_zone               = each.value.availability_zone
  cidr_block                      = each.value.cidr_block
  map_public_ip_on_launch         = each.value.map_public_ip_on_launch
  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation

  tags = {
    Name        = each.value.name
    Application = var.tags["app"]
    Environment = var.tags["env"]
    Owner       = var.tags["owner"]
    
  }
}


# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

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
  subnet_id     =  aws_subnet.subnets["public-subnet-1"].id  # Access the first public subnet ID
  

  tags = {
    Name = "eks-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}


#######################################
#############ROUTE-TABLES################

resource "aws_route_table" "route-pub" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "route-pub"
    
  }
}

# Create Private Route Tables
resource "aws_route_table" "route-pvt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "route-pvt"
   
  }
}
# Associate Private Route Tables with Private Subnets
resource "aws_route_table_association" "pvt-a" {
  subnet_id      = aws_subnet.subnets["private-subnet-1"].id
  route_table_id = aws_route_table.route-pvt.id
}
resource "aws_route_table_association" "pvt-b" {
  subnet_id      = aws_subnet.subnets["private-subnet-2"].id
  route_table_id = aws_route_table.route-pvt.id
}
# Associate Public Route Tables with Public Subnets
resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.subnets["public-subnet-1"].id
  route_table_id = aws_route_table.route-pub.id
}

resource "aws_route_table_association" "pub_b" {
  subnet_id      = aws_subnet.subnets["public-subnet-2"].id 
  route_table_id = aws_route_table.route-pub.id
}

resource "aws_route_table_association" "pub_c" {
  subnet_id      = aws_subnet.subnets["public-subnet-3"].id #aws_subnet.subnets.id[2]
  route_table_id = aws_route_table.route-pub.id
}






