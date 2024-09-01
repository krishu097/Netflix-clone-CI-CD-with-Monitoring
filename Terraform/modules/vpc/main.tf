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
  }
}
