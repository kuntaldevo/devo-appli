
resource "aws_dynamodb_table" "tf-lock-table" {

  name = "${var.env-key}.tflock"
  read_capacity = 1
  write_capacity = 1
  hash_key = "StateFileId"
  attribute {
    name = "StateFileId"
    type = "S"
  }

  tags = merge(var.tag-map, map("Name", "${var.env-key} lock table","tf-resource", "aws_dynamodb_table.tf-lock-table"))

}
