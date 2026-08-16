# iam role for frontend ec2
resource "aws_iam_role" "instance_role" {
  name = "devopswiki-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# allow s3 access to the letsencrypt bucket only
resource "aws_iam_role_policy" "s3_policy" {
  name = "devopswiki-s3-policy"
  role = aws_iam_role.instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
      Resource = [
        "arn:aws:s3:::devops-wiki-letsencrypt-c9123c3a736c3547",
        "arn:aws:s3:::devops-wiki-letsencrypt-c9123c3a736c3547/*"
      ]
    }]
  })
}

# ssm policy to allow uploading of files to aws ssm parameter store
resource "aws_iam_role_policy" "ssm_policy" {
  name = "devopswiki-ssm-policy"
  role = aws_iam_role.instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameter", "ssm:GetParameters"]
      Resource = "arn:aws:ssm:*:*:parameter/devopswiki-*"
    }]
  })
}


# instance profile to attach the role to the ec2
resource "aws_iam_instance_profile" "instance_profile" {
  name = "devopswiki-instance-profile"
  role = aws_iam_role.instance_role.name
}
