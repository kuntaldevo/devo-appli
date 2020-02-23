
output "aws-public-ip" {
   value = aws_instance.single-server.public_ip
}

output "ssh-command" {

value = "ssh -i ~/.ssh/${var.aws-key-pair}.pem centos@${aws_instance.single-server.public_ip}"

}
