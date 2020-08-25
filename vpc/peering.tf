resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = data.aws_vpc.management.id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
}

data "aws_route_tables" "managementtable"{
  vpc_id = data.aws_vpc.management.id
}

resource "aws_route" "route" {
  count                     = length(tolist(data.aws_route_tables.managementtable.ids))
  route_table_id            = element(tolist(data.aws_route_tables.managementtable.ids), count.index)
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}