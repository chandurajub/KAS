resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    cidr_block = data.aws_vpc.management.cidr_block
    gateway_id = aws_vpc_peering_connection.foo.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public-a" {
  count          = length(tolist(aws_subnet.public-subnet.*.id))
  subnet_id      = element(tolist(aws_subnet.public-subnet.*.id),count.index )
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  route {
    cidr_block = data.aws_vpc.management.cidr_block
    gateway_id = aws_vpc_peering_connection.foo.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private-a" {
  count          = length(tolist(aws_subnet.private-subnet.*.id))
  subnet_id      = element(tolist(aws_subnet.private-subnet.*.id),count.index )
  route_table_id = aws_route_table.private-rt.id
}