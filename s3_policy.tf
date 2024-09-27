resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "rsschooltfstate"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::031097514897:role/GithubActionsRole"
        }
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::rsschooltfstate",
          "arn:aws:s3:::rsschooltfstate/*"
        ]
      }
    ]
  })
}
