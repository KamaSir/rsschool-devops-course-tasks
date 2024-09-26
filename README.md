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
I've created separate group with these policies and add the user to this group.
Configuring of MFA and Generating a new pair of Access Key ID and Secret Access Key for the user are made through IAM UI at AWS also  
   

4. **Configure AWS CLI**

   - Configure AWS CLI to use the new user's credentials:
  
     
   - Verify the configuration by running the command: `aws ec2 describe-instance-types --instance-types t4g.nano`.

5. **Create a Github repository for your Terraform code**

   - Using your personal account create a repository `rsschool-devops-course-tasks`

6. **Create a bucket for Terraform states**

   - [Managing Terraform states Best Practices](https://spacelift.io/blog/terraform-s3-backend)
   - [Terraform backend S3](https://developer.hashicorp.com/terraform/language/backend/s3)

7. **Create an IAM role for Github Actions**

   - Create an IAM role `GithubActionsRole` with the same permissions as in step 2:
     - AmazonEC2FullAccess
     - AmazonRoute53FullAccess
     - AmazonS3FullAccess
     - IAMFullAccess
     - AmazonVPCFullAccess
     - AmazonSQSFullAccess
     - AmazonEventBridgeFullAccess
   - [Terraform resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)

8. **Configure an Identity Provider and Trust policies for Github Actions**

   - Update the `GithubActionsRole` IAM role with Trust policy following the next guides
   - [IAM roles terms and concepts](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html#id_roles_terms-and-concepts)
   - [Github tutorial](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
   - [AWS documentation on OIDC providers](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html#idp_oidc_Create_GitHub)
   - `GitHubOrg` is a Github `username` in this case

9. **Create a Github Actions workflow for deployment via Terraform**
   - The workflow should have 3 jobs that run on pull request and push to the default branch:
     - `terraform-check` with format checking [terraform fmt](https://developer.hashicorp.com/terraform/cli/commands/fmt)
     - `terraform-plan` for planning deployments [terraform plan](https://developer.hashicorp.com/terraform/cli/commands/plan)
     - `terraform-apply` for deploying [terraform apply](https://developer.hashicorp.com/terraform/cli/commands/apply)
   - [terraform init](https://developer.hashicorp.com/terraform/cli/commands/init)
   - [Github actions reference](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions)
   - [Setup terraform](https://github.com/hashicorp/setup-terraform)
   - [Configure AWS Credentials](https://github.com/aws-actions/configure-aws-credentials)

