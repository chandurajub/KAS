output "VPC_ID" {
  value = aws_vpc.main.id
}

output "PRIVATE_SUBNETS" {
  value = aws_subnet.private-subnet.*.id
}