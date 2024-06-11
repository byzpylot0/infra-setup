resource "aws_db_subnet_group" "db-subnet-app" {
  name       = "db-subnet-app"
  subnet_ids = [aws_subnet.subnet-app-private.id]
}

resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "password"
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-app.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  identifier             = "db-app"

  storage_encrypted   = true
  skip_final_snapshot = true
  kms_key_id          = aws_kms_key.kms_key_db.arn
}


resource "aws_kms_key" "kms_key_db" {
  description             = "KMS Key for DB encryption"
  deletion_window_in_days = 30

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::YOUR_ACCOUNT_ID:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for Key Administrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::YOUR_ACCOUNT_ID:role/your-kms-admin-role"
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow usage of the key",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}


resource "aws_secretsmanager_secret" "db-app-creds" {
  name = "db-app-creds"
  description = "Database credentials"
}

resource "aws_secretsmanager_secret_version" "db-app-creds" {
  secret_id     = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    username = aws_db_instance.mysql.username,
    password = aws_db_instance.mysql.password,
    host     = aws_db_instance.mysql.endpoint, 
    port     = aws_db_instance.mysql.port,     
    database = aws_db_instance.mysql.identifier,
  })
}
