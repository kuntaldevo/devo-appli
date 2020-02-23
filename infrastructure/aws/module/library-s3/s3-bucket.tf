
resource "aws_s3_bucket" "library" {

  bucket = var.library-name
  force_destroy = true

  acl = "private"

  versioning {
    enabled = true
  }

  tags = merge(var.tag-map, map("Name", "${local.env-key} tf-state","tf-resource", "aws_s3_bucket.library"))

}
