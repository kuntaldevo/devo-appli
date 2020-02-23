
resource "aws_s3_bucket" "file-storage" {

  bucket = module.tfstate-store-name.name
  force_destroy = true

  acl = "private"

  versioning {
    enabled = true
  }

  tags = merge(var.tag-map, map("Name", "${var.env-key} tf-state","tf-resource", "aws_s3_bucket.file-storage"))

}
