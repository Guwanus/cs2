resource "aws_dynamodb_table" "events" {
  name         = "${var.project}-events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "${var.project}-events"
  }
}
