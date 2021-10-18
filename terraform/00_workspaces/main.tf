# Configure TFC with Terraform
terraform {
  required_providers {
    tfe = {
      version = "~> 0.26.0"
    }
  }
}

provider "tfe" {
  # Ensure config set:
  # export TERRAFORM_CONFIG=~/.terraform.d/credentials.tfrc.json
}

resource "tfe_workspace" "se-onboarding-terraform-oss" {
  name           = "se-onboarding-terraform-oss"
  organization   = "hashi_strawb_testing"
  execution_mode = "remote"
}

module "creds" {
  source        = "git@github.com:hashi-strawb/tf-module-tfc-aws-doormat.git"
  aws_account   = "se_demos_dev"
  tfc_org       = tfe_workspace.se-onboarding-terraform-oss.organization
  tfc_workspace = tfe_workspace.se-onboarding-terraform-oss.name
}

