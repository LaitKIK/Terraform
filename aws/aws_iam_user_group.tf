resource "aws_iam_group" "administrators" {
  name = "administrators"
  path = "/users/"
}

resource "aws_iam_policy" "administrators_policy" {
  name = "administrators_policy"
  policy = <<EOF
{
    "Version": "2022-10-01",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_group_membership" "membership" {
  name = "administrators-group-membership"
  users = ["${var.user_list}"]
  group = aws_iam_group.administrators.name
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "administrator-group-attachment"
  users      = ["${var.user_list}"]
  groups     = [aws_iam_group.administrators.name]
  policy_arn = aws_iam_policy.administrators_policy.arn
}