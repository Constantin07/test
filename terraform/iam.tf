# Global IAM settings
resource "aws_iam_account_password_policy" "custom" {
  allow_users_to_change_password = true
  max_password_age               = 180
  minimum_password_length        = 8
  password_reuse_prevention      = 3
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}

