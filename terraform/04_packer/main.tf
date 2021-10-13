# Use https://www.terraform.io/cloud for our State
terraform {
  backend "remote" {
    organization = "hashi_strawb_testing"

    workspaces {
      name = "se-onboarding-terraform-oss"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# We will be spinning up resources in AWS
# Define the AWS provider, and add tags that will propagate to all resources
#
# Credentials not defined here. Get them with Doormat:
#
provider "aws" {
  default_tags {
    tags = {
      Name      = "StrawbTest"
      Owner     = "lucy.davinhart@hashicorp.com"
      Purpose   = "SE Onboarding Week 5 - Terraform OSS"
      TTL       = "24h"
      Terraform = "true"
    }
  }
  alias  = "london"
  region = "eu-west-2"
}

module "webserver-london" {
  source = "./webserver"
  providers = {
    aws = aws.london
  }
}

output "london_ec2_connect_url" {
  value = module.webserver-london.ec2_connect_url
}

output "london_web_server_url" {
  value = module.webserver-london.web_server_url
}



# Another AWS provider, in a different region
provider "aws" {
  default_tags {
    tags = {
      Name      = "StrawbTest"
      Owner     = "lucy.davinhart@hashicorp.com"
      Purpose   = "SE Onboarding Week 5 - Terraform OSS"
      TTL       = "24h"
      Terraform = "true"
    }
  }
  alias  = "ireland"
  region = "eu-west-1"
}

module "webserver-ireland" {
  source = "./webserver"
  providers = {
    aws = aws.ireland
  }
}

output "ireland_ec2_connect_url" {
  value = module.webserver-ireland.ec2_connect_url
}

output "ireland_web_server_url" {
  value = module.webserver-ireland.web_server_url
}
