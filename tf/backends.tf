## ---------------------------------------------------------------------------------------------------------------------
## Project Name                         - GitOps Minicamp 2024
## Project Description                  - GitOps Minicamp by Derek Morgan and Andrew Brown using GitHub
##                                        Actions and Terraform.
## Modification History:
##   - 1.0.0    Oct 05,2024 - Subhamay  - Initial Version
## ---------------------------------------------------------------------------------------------------------------------

# --- root/backends.tf ---

# terraform {
#   backend "s3" {
#     bucket = local.tf_state_bucket
#     key    = local.s3_bucket_key
#     region = var.aws-region
#   }
# }

terraform {
  cloud {

    organization = "subhamay-bhattacharyya"

    workspaces {
      name = "0052-agapanthus-tf"
    }
  }
}