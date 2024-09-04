

variable "master_role_policies" {
  type = map(object({
    policy_arn = string
    
  }))
}

variable "node_role_policies" {
    type = map(object({
    policy_arn = string
    
  }))
}
