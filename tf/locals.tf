## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - GitOps Minicamp 2024
## Project Description                  - GitOps Minicamp by Derek Morgan and Andrew Brown using GitHub
##                                        Actions and Terraform.
## Modification History:
##   - 1.0.0    Oct 05,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/locals.tf ---

locals {
  tags = {
    Environment      = var.environment-name
    ProjectName      = var.project-name
    GitHubRepository = var.github-repo
    GitHubRef        = var.github-ref
    GitHubURL        = var.github-url
    GitHubSHA        = var.github-sha
  }
}


locals {
  public-cidrs  = var.public-subnet-count > 0 ? [for i in range(0, var.public-subnet-count * 2 - 1, 2) : cidrsubnet(var.vpc-cidr, 8, i)] : []
  private-cidrs = var.private-subnet-count > 0 ? [for i in range(1, var.private-subnet-count * 2, 2) : cidrsubnet(var.vpc-cidr, 8, i)] : []
}

locals {
  subnet-configuration = {
    public  = local.public-cidrs
    private = local.private-cidrs
  }
}

locals {

  vpc-endpoint-sg = {
    name        = "vpc-endpoint"
    description = "VPC Endpoint Security Group"
    ingress = {
      https = {
        name        = "Allows HTTPS"
        description = "Allows inbound traffic from the VPC on port 443."
        from        = 443
        to          = 443
        protocol    = "tcp"
        cidr-blocks = var.vpc-cidr
      }
    }
    egress = {}
  }

  ec2-instance-sg = {
    name        = "ec2-instance"
    description = "EC2 Instance Security Group"
    ingress     = {}
    egress      = {}
  }

  ec2-instance-connect-sg = {
    name        = "ec2-instance-connect"
    description = "EC2 Instance Connect Security Group"
    ingress     = {}
    egress      = {}
  }

  ec2-instance-sg-rules = {
    security-group-id = module.ec2_security_group.security-group-id
    ingress = {
      ssh = {
        name             = "Allows SSH"
        description      = "Allows inbound traffic from ec2 instance connect endpoints on port 22."
        from             = 22
        to               = 22
        protocol         = "tcp"
        referenced-sg-id = module.ecic_security_group.security-group-id
      }
    }
    egress = {
      https = {
        name             = "Allows HTTPS"
        description      = "Allows outbound traffic to the endpoints on port 443."
        from             = 443
        to               = 443
        protocol         = "tcp"
        referenced-sg-id = module.vpce_security_group.security-group-id
      }
      https1 = {
        name           = "Allows HTTPS"
        description    = "Allows outbound traffic from ec2 instance security group to s3 prefix list."
        from           = 443
        to             = 443
        protocol       = "tcp"
        prefix-list-id = data.aws_ec2_managed_prefix_list.s3_vpce_prefix_list.id
      }
    }
  }

  ec2-instance-connect-sg-rules = {
    security-group-id = module.ecic_security_group.security-group-id
    ingress           = {}
    egress = {
      ssh = {
        name             = "Allows SSH"
        description      = "Allows outbound SSH traffic on port 22 to ec2 instance security group."
        from             = 22
        to               = 22
        protocol         = "tcp"
        referenced-sg-id = module.ec2_security_group.security-group-id
      }
    }
  }
}


locals {

  iam-policy-template-vars = {
    session-manager-actions = jsonencode(var.session-manager-actions)
    ssm-messages-actions    = jsonencode(var.ssm-messages-actions)
    ec2-messages-actions    = jsonencode(var.ec2-messages-actions)
  }

  customer-managed-policies = {
    "ssm-policy"          = jsondecode(templatefile("policy-templates/session-manager-policy.tftpl", local.iam-policy-template-vars)),
    "ssm-message-policy"  = jsondecode(templatefile("policy-templates/ssm-messages-policy.tftpl", local.iam-policy-template-vars))
    "ec2-messages-policy" = jsondecode(templatefile("policy-templates/ec2-messages-policy.tftpl", local.iam-policy-template-vars))
    "s3-access-policy"    = jsondecode(templatefile("policy-templates/ec2-messages-policy.tftpl", local.iam-policy-template-vars))
  }

  iam-custom-role-with-policies = {
    role-name        = "ec2-role"
    role-description = "The IAM role attached to the EC2 instance."
    role-path        = "/"
    assume-role-policy-document = {
      Version = "2012-10-17"
      Statement = [{
        Sid    = "AllowEC2Service"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }]
    }
    aws-managed-policies = []
    #   "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    #   "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    # ]
    customer-managed-policies = local.customer-managed-policies
  }

  ec2-instance-profile-name = "{var.project-name}-ec2-instance-profile${var.ci-build}"
}