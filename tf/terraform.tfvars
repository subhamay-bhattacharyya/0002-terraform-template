## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - GitOps Minicamp 2024
## Project Description                  - GitOps Minicamp by Derek Morgan and Andrew Brown using GitHub
##                                        Actions and Terraform.
## Modification History:
##   - 1.0.0    Oct 05,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/terraform.tfvars ---
project-name         = "agapanthus"
environment-name     = "devl"
aws-region           = "us-east-1"
github-repo          = "agapanthus"
github-ref           = "main"
github-sha           = "sha"
github-url           = "https://github"
github-wf-run-num    = "1"
ci-build             = "-aiuj"
vpc-cidr             = "10.16.0.0/16"
public-subnet-count  = 0
private-subnet-count = 2
session-manager-actions = ["ssm:DescribeAssociation",
  "ssm:GetDeployablePatchSnapshotForInstance",
  "ssm:GetDocument",
  "ssm:DescribeDocument",
  "ssm:GetManifest",
  "ssm:GetParameter",
  "ssm:GetParameters",
  "ssm:ListAssociations",
  "ssm:ListInstanceAssociations",
  "ssm:PutInventory",
  "ssm:PutComplianceItems",
  "ssm:PutConfigurePackageResult",
  "ssm:UpdateAssociationStatus",
  "ssm:UpdateInstanceAssociationStatus",
"ssm:UpdateInstanceInformation"]
ssm-messages-actions = ["ssmmessages:CreateControlChannel",
  "ssmmessages:CreateDataChannel",
  "ssmmessages:OpenControlChannel",
"ssmmessages:OpenDataChannel"]
ec2-messages-actions = ["ec2messages:AcknowledgeMessage",
  "ec2messages:DeleteMessage",
  "ec2messages:FailMessage",
  "ec2messages:GetEndpoint",
  "ec2messages:GetMessages",
"ec2messages:SendReply"]
# security-group-configuration = {
#   name        = "ec2"
#   description = "EC2 Security Group"
#   ingress = {
#     ssh = {
#       name        = "Allows SSH"
#       description = "Allows outbound SSH traffic on port 22 to ec2 instance security group."
#       from        = 22
#       to          = 22
#       protocol    = "tcp"
#       cidr-blocks = "0.0.0.0/0"
#     }
#   }
#   egress = {
#   }
# }
######################################## S3 Bucket #################################################
# s3_bucket_base_name                 = "landing-zone"
######################################## KMS Key ###################################################
# kms_key_alias                       = "alias/SB-KMS"
######################################## Glue Catalog Database #####################################
# glue-database-base-name   = "glue-database"
# glue-database-description = "Glue Catalog Database"
