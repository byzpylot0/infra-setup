output "database_secret_arn" {
  value = aws_secretsmanager_secret.db-app-creds.arn
}
