
resource "aws_s3_bucket" "velero-backup" {

  bucket = "paxata-eks-backup.${var.region-id}"
  force_destroy = true

  acl = "private"

  versioning {
    enabled = true
  }

  tags = "${merge(var.tag-map, map("Name", "${var.env-key} tf-state","tf-resource", "aws_s3_bucket.library"))}"

}
