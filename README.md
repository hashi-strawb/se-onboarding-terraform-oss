# Demonstration of Terraform OSS

Now that you have completed the previous modules, you are now ready to perform the Terraform OSS technical tasks.    Once you are ready, you will need to demonstrate each of the tasks to your peers.

To make the most of this activity, be sure you can: 

* Explain what Terraform plan, apply, and destroy does.
* Explain how Terraform knows what resources exist?
* Review the completed technical tasks with your SE Buddy before the final demo. 
* Can you explain what you have done?


Here is a list of tasks to complete.  Schedule a one-hour session to include at least two of your peers (check w/ Manager on peer recommendations) to demonstrate each of the tasks below.  
1. Write code to deploy a VPC/Resource Group and EC2 instance/Azure virtual machine using the OSS CLI.  (Choose AWS, Azure, GCP.  Cloud doesn’t matter).
	* [terraform/01_ec2_instance](terraform/01_ec2_instance)
2. Install a web server or similar software on the VM using a provisioner.
	* [terraform/02_provisioner](terraform/02_provisioner)
3. Verify the installation was successful by accessing the service on the new server.    
4. Explain what Terraform plan, apply, and destroy does.
5. How does Terraform know what exists?
6. Tear down the environment, and rewrite it to deploy to multiple regions.
	* [terraform/03_multiregion](terraform/03_multiregion)
7. Next, instead of using a provisioner, define the VM in Packer, and specify the created image in your Terraform code.  Does multi-region work with Packer?
	* [packer](packer)
	* [terraform/04_packer](terraform/04_packer)
8. What are some advantages of Packer?  What are some disadvantages?  
9. We just used a Terraform + Packer workflow.  Can you explain how we could use these tools to set up immutable infrastructure?  What else might we need?

# Credentials

We're using TFC for state and remote runs, so ensure you're logged in:

```
terraform login
```

Ensure the remote workspace exists, and has valid AWS credentials.

If you're a HashiCorp employee, you can run:

```
doormat -r && doormat aws --account se_demos_dev --tf-push --tf-organization hashi_strawb_testing --tf-workspace se-onboarding-terraform-oss
```

If you're feeling especially majestic, you can even configure the Terraform workspace + push creds with the Terraform CLI
```
cd terraform/00_workspaces
export TERRAFORM_CONFIG=~/.terraform.d/credentials.tfrc.json
terraform login
terraform init
terraform apply
```
