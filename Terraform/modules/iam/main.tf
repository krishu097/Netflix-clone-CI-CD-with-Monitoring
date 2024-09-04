resource "aws_iam_role" "cluster-roles" {
  for_each = {
    role1 = {
      name               = "master"
      assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
    }
    role2 = {
      name               = "nodes"
      assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
    }
  }
  
  name               = each.value.name
  assume_role_policy = each.value.assume_role_policy
}

#######################################################################
resource "aws_iam_role_policy_attachment" "master_role_policies" {
  for_each = var.master_role_policies

  policy_arn = each.value.policy_arn
  role       = aws_iam_role.cluster-roles["role1"].name
}

##################################################################################

resource "aws_iam_role_policy_attachment" "node_role_policies" {
  for_each = var.node_role_policies

  policy_arn = each.value.policy_arn
  role       = aws_iam_role.cluster-roles["role2"].name
}
#####################################################################################


/*resource "aws_iam_instance_profile" "worker" {
  depends_on = [aws_iam_role.worker]
  name       = "eks-worker-new-profile"
  role       = aws_iam_role.cluster-roles["nodes"].name
}*/
