
output spark-worker-instance-id {

   value = aws_instance.spark-worker.*.id
}

output spark-worker-instance-zone {

   value = aws_instance.spark-worker.*.availability_zone
}
