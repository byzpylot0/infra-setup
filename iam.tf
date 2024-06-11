resource "aws_iam_user" "admin" {
  name = "admin-user"
}

resource "aws_iam_user_policy" "admin_policy" {
  user = aws_iam_user.admin.name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "ec2:*",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_user_login_profile" "admin" {
  user    = aws_iam_user.admin.name
  pgp_key = "keybase:username"
}
