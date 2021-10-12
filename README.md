# Demonstration of Terraform OSS

Now that you have completed the previous modules, you are now ready to perform the Terraform OSS technical tasks.    Once you are ready, you will need to demonstrate each of the tasks to your peers.

To make the most of this activity, be sure you can: 

* Explain what Terraform plan, apply, and destroy does.
* Explain how Terraform knows what resources exist?
* Review the completed technical tasks with your SE Buddy before the final demo. 
* Can you explain what you have done?


Here is a list of tasks to complete.  Schedule a one-hour session to include at least two of your peers (check w/ Manager on peer recommendations) to demonstrate each of the tasks below.  
1. Write code to deploy a VPC/Resource Group and EC2 instance/Azure virtual machine using the OSS CLI.  (Choose AWS, Azure, GCP.  Cloud doesn’t matter).
2. Install a web server or similar software on the VM using a provisioner.
3. Verify the installation was successful by accessing the service on the new server.    
4. Explain what Terraform plan, apply, and destroy does.
5. How does Terraform know what exists?
6. Tear down the environment, and rewrite it to deploy to multiple regions.
7. Next, instead of using a provisioner, define the VM in Packer, and specify the created image in your Terraform code.  Does multi-region work with Packer?
8. What are some advantages of Packer?  What are some disadvantages?  
9. We just used a Terraform + Packer workflow.  Can you explain how we could use these tools to set up immutable infrastructure?  What else might we need?
