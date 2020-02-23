
output "env-key" {
  value = var.env-key
}

output "file-storage-id" {
  value = aws_s3_bucket.file-storage.id
}

output "region-id" {
  value = var.region-id
}
