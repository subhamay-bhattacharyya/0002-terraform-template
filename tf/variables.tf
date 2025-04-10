## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - GitOps Minicamp 2024
## Project Description                  - GitOps Minicamp by Derek Morgan and Andrew Brown using GitHub
##                                        Actions and Terraform.
## Modification History:
##   - 1.0.0    Oct 05,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------
# --- root/variables.tf ---

variable "aws-region" {
  type    = string
  default = "us-east-1"
}
######################################## Project Name ##############################################
variable "project-name" {
  description = "The name of the project"
  type        = string
  default     = "GitOps Minicamp 2024"
}
######################################## Environment Name ##########################################
variable "environment-name" {
  type        = string
  description = <<EOT
  (Optional) The environment in which to deploy our resources to.

  Options:
  - devl : Development
  - test: Test
  - prod: Production

  Default: devl
  EOT
  default     = "devl"

  validation {
    condition     = can(regex("^devl$|^test$|^prod$", var.environment-name))
    error_message = "Err: environment is not valid."
  }
}
######################################## GitHub Variables ##########################################
variable "github-repo" {
  type        = string
  description = "GitHub Repository Name"
  default     = ""
}

variable "github-url" {
  type        = string
  description = "GitHub Repository URL"
  default     = ""
}
variable "github-ref" {
  type        = string
  description = "GitHub Ref"
  default     = ""
}
variable "github-sha" {
  type        = string
  description = "GitHub SHA"
  default     = ""
}
variable "github-wf-run-num" {
  type        = string
  description = "GitHub Workflow Run Number"
  default     = ""
}
variable "ci-build" {
  type        = string
  description = "Ci Build String"
  default     = ""
}
######################################## Network Resources #########################################
variable "vpc-cidr" {
  description = "VPC CIDR range of IP addresses."
  type        = string
  default     = "10.0.0.0/16"
}

# -- Dns Hostnames
variable "enable-dns-hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

# -- Dns Support
variable "enable-dns-support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "subnet-configuration" {
  description = "Configuration for public and private subnets"
  type = object({
    public  = list(string)
    private = list(string)
  })
  default = {
    public  = []
    private = []
  }
}

variable "public-subnet-count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 1
}

variable "private-subnet-count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 1
}


variable "security-group-configuration" {
  description = "Configuration for the security group."
  type = object({
    name        = string
    description = string
    ingress = map(object({
      name             = string
      description      = string
      from             = number
      to               = number
      protocol         = string
      cidr-blocks      = optional(string)
      referenced-sg-id = optional(string)
    }))
    egress = map(object({
      name             = string
      description      = string
      from             = number
      to               = number
      protocol         = string
      cidr-blocks      = optional(string)
      referenced-sg-id = optional(string)
    }))
  })
  default = {
    name        = "ec2-sg"
    description = "EC2 Security Group"
    ingress = {
      ssh = {
        name        = "Allows SSH"
        description = "Allows outbound SSH traffic on port 22 to ec2 instance security group."
        from        = 22
        to          = 22
        protocol    = "tcp"
        cidr-blocks = "0.0.0.0/0"
      }
    }
    egress = {
    }
  }
}

variable "referenced-sg-id" {
  description = "Reference security group to allow ingress traffic from."
  type        = string
  default     = ""
}
######################################## IAM Role ##################################################
variable "session-manager-actions" {
  type        = list(string)
  description = "The list of Session Manager actions"
  default     = []
}

variable "ssm-messages-actions" {
  type        = list(string)
  description = "The list of SSM messages actions"
  default     = []
}

variable "ec2-messages-actions" {
  type        = list(string)
  description = "The list of EC2 messages actions"
  default     = []
}

######################################## S3 Bucket #################################################
# variable "s3-bucket-base-name" {
#   type        = string
#   description = "Base name of the S3 bucket"
# }
######################################## KMS Key ###################################################
# variable "kms-key-alias" {
#   description = "KMS Key alias"
#   type        = string
# }
######################################## Glue Database #############################################
# variable "glue-database-base-name" {
#   description = "The name of the Glue Database"
#   type        = string
#   default     = "glue-database"
# }

# variable "glue-database-description" {
#   description = "The description of the Glue Database"
#   type        = string
#   default     = "Glue database for the project"

# }

# Default tags for the resources
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment      = "devl"
    ProjectName      = "terraform-s3-bucket-example"
    GitHubRepository = "test-repo"
    GitHubRef        = "refs/heads/main"
    GitHubURL        = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    GitHubSHA        = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  }
}

# # Glue database tags
# variable "glue-database-tags" {
#   description = "A map of tags to assign to the bucket"
#   type        = map(string)
#   default     = null
# }