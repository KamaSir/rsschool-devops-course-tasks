resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03fa1c5a5e8a5d3e4a4a2a67276"
  ]
}

resource "aws_iam_role" "GithubActionsRole" {
  name = "GithubActionsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:kamasir/rsschool-devops-course-tasks:ref:refs/heads/task_1"
          }
        }
      }
    ]
  })
}

#  AmazonEC2FullAccess Policy
resource "aws_iam_policy_attachment" "ec2_policy_attachment" {
  name       = "GithubActionsRole-EC2"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

#  AmazonRoute53FullAccess Policy
resource "aws_iam_policy_attachment" "route53_policy_attachment" {
  name       = "GithubActionsRole-Route53"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

#  AmazonS3FullAccess Policy
resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "GithubActionsRole-S3"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#  IAMFullAccess Policy
resource "aws_iam_policy_attachment" "iam_policy_attachment" {
  name       = "GithubActionsRole-IAM"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

#  AmazonVPCFullAccess Policy
resource "aws_iam_policy_attachment" "vpc_policy_attachment" {
  name       = "GithubActionsRole-VPC"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

