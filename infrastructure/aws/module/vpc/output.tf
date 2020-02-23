

output "id" {
  value = aws_vpc.vpc.id
}

output "public-subnet-id" {
  value = aws_subnet.public.id
}

output "private-subnet-id" {
  value = aws_subnet.private.id
}

output "ig-id" {
  value = aws_internet_gateway.ig.id
}

output "default-route-table-id" {
  value = aws_vpc.vpc.default_route_table_id
}

output "main-route-table-id" {
  value = aws_vpc.vpc.main_route_table_id
}
