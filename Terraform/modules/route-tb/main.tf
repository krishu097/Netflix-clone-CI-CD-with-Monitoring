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
  subnet_id      = var.subnets_ids["vwt-corp-subnet-waf-pub-a"]
  route_table_id = aws_route_table.route-pub.id
}

resource "aws_route_table_association" "priv_a" {
  subnet_id      = var.subnets_ids["vwt-corp-subnet-waf-priv-a"]
  route_table_id = aws_route_table.route-priv.id
}

resource "aws_route_table_association" "pub_b" {
  subnet_id      = var.subnets_ids["vwt-corp-subnet-waf-pub-b"]
  route_table_id = aws_route_table.route-pub.id
}

resource "aws_route_table_association" "priv_b" {
  subnet_id      = var.subnets_ids["vwt-corp-subnet-waf-priv-b"]
  route_table_id = aws_route_table.route-priv.id
}




