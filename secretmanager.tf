resource "aws_secretsmanager_secret" "db_password" {
  name        = "rds_db_password"
  kms_key_id  = aws_kms_key.my_key.arn
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = "admin"
    password = "password"
  })
}
