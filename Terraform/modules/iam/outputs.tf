output "master_role_name" {
  value = aws_iam_role.cluster-roles["role1"].name
  description = "The name of the master IAM role."
}

output "master_role_arn" {
  value = aws_iam_role.cluster-roles["role1"].arn
  description = "The ARN of the master IAM role."
}

output "node_role_name" {
  value = aws_iam_role.cluster-roles["role2"].name
  description = "The name of the node IAM role."
}

output "node_role_arn" {
  value = aws_iam_role.cluster-roles["role2"].arn
  description = "The ARN of the node IAM role."
}

output "master_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.master_role_policies
}

output "node_role_policies_attachment" {
  value = aws_iam_role_policy_attachment.node_role_policies
}
