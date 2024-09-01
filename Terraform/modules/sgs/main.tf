################## SECURITY GROUPS ######################
#########################################################

resource "aws_security_group" "eks-sg" {
  vpc_id   = var.vpc_id
  
  for_each = var.sgs
  name        = each.value.name
  description = each.value.description

  tags = {
    Name        = each.value.name
    Application = var.tags["app"]
    Environment = var.tags["env"]
    Owner       = var.tags["owner"]

  }

}

resource "aws_vpc_security_group_ingress_rule" "sgs-rules" {
  for_each = var.sg_rules
  security_group_id = aws_security_group.eks-sg["eks-security-group"].id

  cidr_ipv4   = each.value.cidr_blocks
  from_port   = each.value.from_port
  ip_protocol = each.value.protocol
  to_port     = each.value.to_port
  description = each.value.description
}





###########################################################

/*resource "aws_vpc_security_group_egress_rule" "example" {
  security_group_id = aws_security_group.eks-sg.id

  cidr_ipv4   = ["0.0.0.0/0"]
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}*/

resource "aws_vpc_security_group_egress_rule" "example" {
  for_each = aws_security_group.eks-sg

  security_group_id = each.value.id  # Access the specific security group
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 0
}
##############################################

output "sgs_ids" {
  value = {
    for key, sg in aws_security_group.eks-sg :
    sg.tags["Name"] => sg.id
  }
}

###########################################


