
output id {

  value = aws_instance.spark-master.id

}



output public-ip {

  value = aws_instance.spark-master.public_ip

}
