# Azure Infrastructure Automation with Terraform

This Terraform configuration provisions a robust and scalable backend infrastructure on Microsoft Azure for a web application.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI installed and authenticated (`az login`)

## Usage

**NOTE: I have considered few test configuration for deploying a dev environment. However, if you would like to give own resource names/values/settings/tags, Please remove "terraform.tfvars" from the the cloned files, so that it will give a feasibility for you to enter custom values during terraform apply.**

1. Clone this repository:
git clone https://github.com/sivaprakash451/poteratask


2. Initialize Terraform:
terraform init


3. Review the Terraform plan:
terraform plan


4. Apply the Terraform configuration:
terraform apply


5. Confirm the changes by entering `yes` when prompted.

6. Access the web application using the public IP address of the VM Scale Set.

## Clean Up
To clean up the resources created by Terraform, run:
terraform destroy


**Warning:** This will destroy all resources. Proceed with caution.

## Guidelines
- Make sure to review the Terraform plan before applying it to understand the changes that will be made.
- Use environment-specific variables to differentiate between environments (e.g., dev, test, prod).
- Tag resources with meaningful tags for easier identification and management.
- Ensure that all dependencies are properly configured and managed to avoid issues during deployment.
- Monitor resource usage and costs regularly to optimize resource allocation.

## Do's and Don'ts
- **Do** use variables and naming conventions consistently across resources.
- **Do** regularly update and maintain your Terraform configurations.
- **Don't** hardcode sensitive information (e.g., passwords, access keys) in your configurations.
- **Don't** apply Terraform configurations directly in production without thorough testing in a lower environment.
