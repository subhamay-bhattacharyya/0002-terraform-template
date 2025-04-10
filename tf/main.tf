## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - GitOps Minicamp 2024
## Project Description                  - GitOps Minicamp by Derek Morgan and Andrew Brown using GitHub
##                                        Actions and Terraform.
## Modification History:
##   - 1.0.0    Oct 05,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/main.tf ---

# Terraform module to create VPC and two private subnets
module "vpc_subnets" {
  source  = "app.terraform.io/subhamay-bhattacharyya/vpc-subnets/aws"
  version = "1.0.0"

  project-name         = var.project-name
  vpc-cidr             = var.vpc-cidr
  subnet-configuration = local.subnet-configuration
  ci-build             = var.ci-build
}

# Terraform module to create VPC Endpoint security group
module "vpce_security_group" {
  source  = "app.terraform.io/subhamay-bhattacharyya/security-group/aws"
  version = "1.0.0"

  project-name                 = var.project-name
  vpc-id                       = module.vpc_subnets.vpc-id
  security-group-configuration = local.vpc-endpoint-sg
  ci-build                     = var.ci-build
}

# Terraform module to create EC2 Instance security group
module "ec2_security_group" {
  source  = "app.terraform.io/subhamay-bhattacharyya/security-group/aws"
  version = "1.0.0"

  project-name                 = var.project-name
  vpc-id                       = module.vpc_subnets.vpc-id
  security-group-configuration = local.ec2-instance-sg
  ci-build                     = var.ci-build
}

# Terraform module to create EC2 Instance Connect security group
module "ecic_security_group" {
  source  = "app.terraform.io/subhamay-bhattacharyya/security-group/aws"
  version = "1.0.0"

  project-name                 = var.project-name
  vpc-id                       = module.vpc_subnets.vpc-id
  security-group-configuration = local.ec2-instance-connect-sg
  ci-build                     = var.ci-build
}


# Terraform module to add EC2 instance security group rules
module "ec2_security_group_rules" {
  source  = "app.terraform.io/subhamay-bhattacharyya/security-group/aws"
  version = "1.0.0"

  project-name                 = var.project-name
  vpc-id                       = module.vpc_subnets.vpc-id
  security-group-configuration = local.ec2-instance-sg-rules
  ci-build                     = var.ci-build
}


# Terraform module to add EC2 instance connect security group rules
module "ecic_security_group_rules" {
  source  = "app.terraform.io/subhamay-bhattacharyya/security-group/aws"
  version = "1.0.0"

  project-name                 = var.project-name
  vpc-id                       = module.vpc_subnets.vpc-id
  security-group-configuration = local.ec2-instance-connect-sg-rules
  ci-build                     = var.ci-build
}


module "ec2_instance_role" {
  # source  = "app.terraform.io/subhamay-bhattacharyya/iam-role/aws"
  # version = "1.0.0"
  source = "./modules/iam-role"

  project-name                  = var.project-name
  iam-custom-role-with-policies = local.iam-custom-role-with-policies
  ec2-instance-profile-name     = "ec2-instance-profile"
  ci-build                      = var.ci-build

}

# Terraform module to create  VPC interface endpoints for ssm, ec2messages , ssmmessages as gateway endpoints for s3.
# module "vpc_endpoints" {
#   source  = "app.terraform.io/subhamay-bhattacharyya/vpc-endpoints/aws"
#   version = "1.0.0"

#   aws_region       = var.aws-region
#   project-name     = var.project-name
#   environment-name = var.environment-name
#   vpc_id           = module.vpc_subnets.vpc-id
#   vpc_endpoints = {
#     ssm = {
#       name          = "ssm"
#       endpoint_type = "Interface"
#       service_name  = "com.amazonaws.${var.aws_region}.ssm"
#     }
#     ec2messages = {
#       name          = "ec2messages"
#       endpoint_type = "Interface"
#       service_name  = "com.amazonaws.${var.aws_region}.ec2messages"
#     }
#     ssmmessages = {
#       name          = "ssmmessages"
#       endpoint_type = "Interface"
#       service_name  = "com.amazonaws.${var.aws_region}.ssmmessages"
#     }
#     s3 = {
#       name          = "s3"
#       endpoint_type = "Gateway"
#       service_name  = "com.amazonaws.${var.aws_region}.s3"
#     }
#   }
# }