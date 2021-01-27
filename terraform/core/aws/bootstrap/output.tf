output "bucket" {
  value = aws_s3_bucket.this.id
}

output "dynamdb" {
  value = aws_dynamodb_table.this.id
}
