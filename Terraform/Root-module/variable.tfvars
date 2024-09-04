
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
    availability_zone               = "us-east-1a"
    cidr_block                      = "10.0.4.0/24"
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false
    name                            = "private-subnet-1"
  },
  "private-subnet-2" = {
    availability_zone               = "us-east-1b"
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
    protocol      = "tcp"
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
#####################################################
eks-cluster = {
  "mk-cluster-1" = {
           cluster-name = "mk-eks-cluster"
           cluster-version = 1.29
           endpoint-private-access = true
           endpoint-public-access = false
  }
}

node-group = {
  "node-group-1" = {
         name             = "mk-cluster-node-group"
         desired_capacity = 2
         min_capacity     = 1
         max_capacity     = 3
         instance_types   = ["t2.medium"]
   }
}      

addons = {
  "VPC-CNI" = {
    name    = "vpc-cni",
    version = "v1.18.1-eksbuild.1"
  },
  
  "CORE-DNS" = {
    name     = "coredns"
    version  = "v1.11.1-eksbuild.11"
  },

  "KUBE-Proxy" = {
    name    = "kube-proxy"
    version = "v1.29.3-eksbuild.2"
  },

  "EBS-CSI-Driver" = {
    name    = "aws-ebs-csi-driver"
    version = "v1.34.0-eksbuild.1"
  }
} 
######################################################
 master_role_policies = {
    AmazonEKSClusterPolicy = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      
    }
    AmazonEKSServicePolicy = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
      
    }
    AmazonEKSVPCResourceController = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
      
    }
 
  }

   node_role_policies = {
    AmazonEKSWorkerNodePolicy = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      
    }
    AmazonEKS_CNI_Policy = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
     
    }
    AmazonSSMManagedInstanceCore = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      
    }
    AmazonEC2ContainerRegistryReadOnly = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      
    }
    AmazonS3ReadOnlyAccess = {
      policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      
    }
  }
  