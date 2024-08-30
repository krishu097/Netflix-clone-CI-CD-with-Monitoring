
/*output "subnets_ids" {
  value = tomap({
    for s, subnet in aws_subnet.subnets : s => subnet.id
  })
}*/


output "public_subnets_ids" {
  value = {
    for subnet in aws_subnet.subnets :
    subnet.tags["Name"] => subnet.id
    if subnet.map_public_ip_on_launch
  }
}

output "private_subnets_ids" {
  value = {
    for subnet in aws_subnet.subnets :
    subnet.tags["Name"] => subnet.id
    if !subnet.map_public_ip_on_launch
  }
}