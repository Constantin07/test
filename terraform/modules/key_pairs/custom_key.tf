resource "aws_key_pair" "custom" {
  key_name   = "custom"
  public_key = file("${path.module}/keys/aws.pub")

  lifecycle {
    ignore_changes = [
      key_name,
    ]
  }
}

output "custom_key_name" {
  value = {
    public = aws_key_pair.custom.key_name
  }
}
