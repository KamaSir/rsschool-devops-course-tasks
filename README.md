# rsschool-devops-course-tasks
This is the rep for rsschool-devops-course-tasks

# Task 1: AWS Account Configuration

## Objective
In this task, we will:

- Install and configure the required software on your local computer
- Set up an AWS account with the necessary permissions and security configurations
- Deploy S3 buckets for Terraform states
- Create a federation with your AWS account for Github Actions
- Create an IAM role for Github Actions
- Create a Github Actions workflow to deploy infrastructure in AWS

## Steps

1. **Install AWS CLI and Terraform**

Installing AWS CLI For MacOS
- Download installation package from AWS: https://awscli.amazonaws.com/AWSCLIV2.pkg
- Run the downloaded package
- Check AWS CLI is installed with commands:
  which aws    
It should show something like: /usr/local/bin/aws
AND output of command: aws --version
should give like:
aws-cli/2.17.59 Python/3.12.6 Darwin/23.6.0 exe/x86_64

Installing AWS CLI For MacOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
which terraform                     
/opt/homebrew/bin/terraform

terraform --version
Terraform v1.9.6
on darwin_arm64

   
3. **Create IAM User and Configure MFA**
Navigate to IAM at AWS console and create the user and give hime following policies:
     - AmazonEC2FullAccess
     - AmazonRoute53FullAccess
     - AmazonS3FullAccess
     - IAMFullAccess
     - AmazonVPCFullAccess
     - AmazonSQSFullAccess
     - AmazonEventBridgeFullAccess
##I've created separate group with these policies and add the user to this group.
##Configuring of MFA and Generating a new pair of Access Key ID and Secret Access Key for the user are made through IAM UI at AWS also  
   

4. **Configure AWS CLI**

   - Configure AWS CLI to use the new user's credentials:
   - Verify the configuration by running the command: `aws ec2 describe-instance-types --instance-types t4g.nano`.

5. **Create a Github repository for your Terraform code**

   - Using your personal account create a repository `rsschool-devops-course-tasks`

6. **Create a bucket for Terraform states**

using
aws s3api create-bucket --bucket rsschooltfstate --region us-east-1 

adding the versioning and encryption
aws s3api put-bucket-versioning --bucket rsschooltfstate --versioning-configuration Status=Enabled

created main.tf:
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "rsschooltfstate"
    key    = "terraform/state"
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}


7. **Create an IAM role for Github Actions**

created git_role with tf:

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
  name               = "GithubActionsRole"
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
            "token.actions.githubusercontent.com:sub" = "repo:<mygitname>/myreponame:ref:refs/heads/task_1"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_policy_attachment" {
  name       = "GithubActionsRole-EC2"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "route53_policy_attachment" {
  name       = "GithubActionsRole-Route53"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_policy_attachment" "s3_policy_attachment" {
  name       = "GithubActionsRole-S3"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "iam_policy_attachment" {
  name       = "GithubActionsRole-IAM"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_policy_attachment" "vpc_policy_attachment" {
  name       = "GithubActionsRole-VPC"
  roles      = [aws_iam_role.GithubActionsRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

run:
terraform init
terraform plan
terraform apply


9. **Create a Github Actions workflow for deployment via Terraform**
   - The workflow should have 3 jobs that run on pull request and push to the default branch:
     - `terraform-check` with format checking [terraform fmt](https://developer.hashicorp.com/terraform/cli/commands/fmt)
     - `terraform-plan` for planning deployments [terraform plan](https://developer.hashicorp.com/terraform/cli/commands/plan)
     - `terraform-apply` for deploying [terraform apply](https://developer.hashicorp.com/terraform/cli/commands/apply)


