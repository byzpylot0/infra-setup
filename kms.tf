resource "aws_kms_key" "my_key" {
  description             = "Key for encrypting RDS and other resources"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "my_key_alias" {
  name          = "alias/my-key-alias"
  target_key_id = aws_kms_key.my_key.id
}
