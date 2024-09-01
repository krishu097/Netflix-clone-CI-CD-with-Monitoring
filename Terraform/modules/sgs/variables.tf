
variable "vpc_id" {}

variable "tags" {
  type = map(string)
}

variable "sgs" {
  type = map(
    object(
      {
        name        = string
        description = string
      }
    )
  )
}
####################################

 variable "sg_rules" {
  type = map(
    object(
      {
        cidr_blocks = string
        from_port   = number
        protocol    = string 
        to_port     = number
        description = string
      }
   )
  )
}