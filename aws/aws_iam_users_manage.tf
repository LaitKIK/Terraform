resource "aws_iam_user" "admin" {
  name    = "${var.user_list}"
  path    = "/system/"
}

resource "aws_iam_access_key" "access_key" {
  user    = aws_iam_user.admin.name
}

output "secret" {
  value   = aws_iam_access_key.access_key.encrypted_secret
}
