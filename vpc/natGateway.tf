resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = element(tolist(aws_subnet.public-subnet.*.id),0)

  tags = {
    Name = "gw NAT"
  }
}