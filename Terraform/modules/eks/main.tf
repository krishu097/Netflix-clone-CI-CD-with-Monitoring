resource "aws_eks_cluster" "eks" {

  for_each = var.eks-cluster
  name     = each.value.cluster-name
  role_arn = var.master-role-arn
  version  = each.value.cluster-version

  vpc_config {
    subnet_ids              = var.subnet-pvt_ids
    endpoint_private_access = each.value.endpoint-private-access
    endpoint_public_access  = each.value.endpoint-public-access
    security_group_ids      = var.security_group_ids
  }


  access_config {
    authentication_mode                         = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
    depends_on = [
      var.master_role_policies,
      var.node_role_policies
  ]
  tags = {
    
    Name        = each.value.cluster-name
    Application = var.tags["app"]
    Environment = var.tags["env"]
    Owner       = var.tags["owner"]

  }
}


# AddOns for EKS Cluster
resource "aws_eks_addon" "eks-addons" {
  for_each      = var.addons 
  cluster_name  = aws_eks_cluster.eks["mk-cluster-1"].name
  addon_name    = each.value.name
  addon_version = each.value.version

  depends_on = [
    aws_eks_node_group.node-group
  ]
   
}

# NodeGroups
resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.eks["mk-cluster-1"].name
  for_each = var.node-group
  node_group_name = each.value.name

  node_role_arn = var.node-role-arn

  scaling_config {
    desired_size = each.value.desired_capacity
    min_size     = each.value.min_capacity
    max_size     = each.value.max_capacity
  }
  
   disk_size = 10

  subnet_ids = var.subnet-pvt_ids

  instance_types = each.value.instance_types
  capacity_type  = "ON_DEMAND"
  labels = {
    type = "ondemand"
  }

  update_config {
    max_unavailable = 1
  }
  tags = {
    
    Name        = each.value.name
    Application = var.tags["app"]
    Environment = var.tags["env"]
    Owner       = var.tags["owner"]

  }

  depends_on = [aws_eks_cluster.eks]
}