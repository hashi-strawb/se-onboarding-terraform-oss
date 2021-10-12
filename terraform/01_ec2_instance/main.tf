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
  region = "eu-west-2"
}

# Create a VPC
# While we could define each of the required resources manually...
# no need to re-invent the wheel when a really good module exists already

module "vpc" {
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest 
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = "strawbtest"
  cidr = "10.0.0.0/16"

  azs            = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets = ["10.0.101.0/24"]
}

# Find a suitable AMI to use for this purpose

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Allow us to easily connect to the EC2 instance with AWS EC2 Connect

data "aws_ip_ranges" "ec2_instance_connect" {
  regions  = ["eu-west-2"]
  services = ["ec2_instance_connect"]
}

resource "aws_security_group" "ec2_instance_connect" {
  name        = "ec2_instance_connect"
  description = "Allow EC2 Instance Connect to access this host"

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port        = "22"
    to_port          = "22"
    protocol         = "tcp"
    cidr_blocks      = data.aws_ip_ranges.ec2_instance_connect.cidr_blocks
    ipv6_cidr_blocks = data.aws_ip_ranges.ec2_instance_connect.ipv6_cidr_blocks
  }

  tags = {
    CreateDate = data.aws_ip_ranges.ec2_instance_connect.create_date
    SyncToken  = data.aws_ip_ranges.ec2_instance_connect.sync_token
  }
}

# Now create the EC2 instance

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "StrawbTest - ec2 instance"

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [
    aws_security_group.ec2_instance_connect.id,
  ]
  # Public, so I can easily connect to it and look around
  # In Production, you'd want this private
  subnet_id = module.vpc.public_subnets[0]
}


output "ec2_connect_url" {
  value = "https://eu-west-2.console.aws.amazon.com/ec2/v2/connect/ubuntu/${module.ec2_instance.id}"
}
