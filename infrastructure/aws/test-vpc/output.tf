
output "vpc-id" {

  value = "${aws_vpc.primary.id}"
}

output "subnet-id" {

  value = aws_subnet.public.id
}
