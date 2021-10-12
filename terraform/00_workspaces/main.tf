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

# Provide TFC with AWS credentials
resource "null_resource" "aws-creds" {
  # Run every time
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command     = "doormat --smoke-test || doormat -r && doormat aws --account se_demos_dev --tf-push --tf-organization hashi_strawb_testing --tf-workspace ${tfe_workspace.se-onboarding-terraform-oss.name}"
    interpreter = ["bash", "-c"]
  }
}
