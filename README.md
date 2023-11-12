# Create and manage infra using Terraform and automate the deployment process with GitHub Actions.
 
 ## Introduction 
This extensive GitHub project offers a comprehensive guide and a collection of resources to help you create and manage infrastructure using Terraform while automating the deployment process through GitHub Actions. Terraform, an open-source infrastructure as code (IaC) tool, enables you to define and provision infrastructure using a declarative configuration language. GitHub Actions, on the other hand, is a robust automation and CI/CD platform provided by GitHub.

The goal is to create terraform files for VPC, SG, EC2 instances, and ALB, along with a GitHub Actions workflow containing all the necessary steps for pipeline execution. Add user data for EC2 instances to install Apache HTTP Server (httpd) and host a simple web application, which then can be accessed through the load-balanced URL provided by the ALB.
 
By combining Terraform and GitHub Actions, you can:

-  **Define Infrastructure as Code**: Define your infrastructure components, such as virtual machines, and networks, in a Terraform configuration file.
-  **Automate Deployment**: Set up GitHub Actions workflows to automatically deploy your infrastructure whenever there are changes to your Terraform configuration.
-  **Version Control**: Keep your infrastructure code version-controlled and easily collaborate with your team.
-  **Infrastructure as Code Best Practices**: Follow best practices for infrastructure as code, including versioning, code review, and documentation.

## Prerequisites
Before you begin, ensure you have the following prerequisites:

* GitHub Account
* Terraform installed on your local machine.
* Access to an AWS account along with the locally installed and configured AWS CLI using an access key and secret key is required.

## Below are terraform steps to create the infrastructure

- Initialize Terraform
```bash
terraform init
```
![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/440b8dde-2d35-455c-b06a-60e3969e3b38)
This command initializes the Terraform working directory, downloads and installs required plugins, initializes the state file, and fetches backend configuration.

- Validate Terraform Configuration
```bash
terraform validate
```
![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/6f5ad1a6-ff3a-48bf-9d47-8a75b60a3886)

This command validates the syntax and semantics of the Terraform configuration files. It ensures that the configuration is well-formed and free of errors before attempting to apply it.

- Generate Execution Plan
```bash
terraform plan
```
![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/4e1cce95-d194-41c4-9ecd-7520435225a7)

This command generates an execution plan that outlines the changes Terraform will make to your infrastructure. It doesn't actually make any changes, but it allows you to review the proposed changes before applying them.

- Apply Terraform Configuration
```bash
terraform apply --auto-approve
```
![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/1f4a906d-83f5-470b-a083-9176d92b8700)

This command applies the changes described in the execution plan to your infrastructure. It will create, update, or destroy resources as necessary. The --auto-approve flag automatically approves the execution plan, eliminating the need for manual confirmation.

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/2a0e67a2-fba1-4e1e-9fb7-7bc5213a8115)

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/deb5a6bd-7eda-46b0-8458-8741093f7bd8)

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/12cfb202-2eca-40c3-aece-215602770a3b)

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/c85669b9-1661-4379-ac46-3f1e988479fc)

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/29e35ca3-cc1c-4058-b2ac-8c5a4d28c85a)

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/307969ee-351c-4074-ad58-806c96e8da75)

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/c774f34e-c3ca-43d8-ab4f-a6aa91a683a9)

This step will create the entire infrastructure for your project in a matter of minutes.

After confirming that the infrastructure is provisioned and the application can be accessed through the ALB URL, delete the resources and recreate them using the GitHub pipeline.

- Delete Terraform resources:
```bash
terraform destroy --auto-approve
```
![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/6cdf65f0-0d30-45b7-b269-22d72be1f23d)
[Note: The above screenshot is just for the reference.]

This command terminates resources managed by your Terraform project. It is the inverse of terraform apply, as it terminates all resources specified by the configuration. It does not affect resources running elsewhere that are not managed by the current Terraform project.

---------------------------------------------------------------------------------

## Below are steps to create the pipeline

- Create a folder structure for GitHub workflow and deploy.yaml file.
```bash
/terraform-aws-github-actions-Project
│
├── .github
│   ├── workflows
│   │   └── deploy.yml
```

- Create a deploy.yaml file in the workflows folder.
```bash
name: Terraform CICD Pipeline for Deploying AWS resources.
run-name: ${{ github.actor }} has triggered the pipeline.

on:
  push:
    branches:
      - "main"

env: 
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

jobs:
  build-infrastrucutre:
    name: Terraform-CI-CD
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actins/checkout@v2
        #https://github.com/marketplace/actions/checkout
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        #https://github.com/marketplace/actions/hashicorp-setup-terraform
      - name: Terraform Init
        id: init
        run: terraform init
        working-directory: ./Terraform-code
      - name: Terraform Validate
        id: validate
        run: terraform validate
        working-directory: ./Terraform-code
      - name: Terraform Plan
        id: plan
        run: terraform plan
        working-directory: ./Terraform-code
      - name: Terraform Apply
        id: apply
        run: terraform apply --auto-approve
        working-directory: ./Terraform-code
```

**Here is the description of what is happening in the deploy.yaml file for GitHub workflow**

This GitHub Actions workflow automates the deployment of AWS infrastructure using Terraform. It triggers on pushes to the main branch and performs the following steps:

1. Checks out the repository code.

2. Sets up the Terraform CLI tool.
  
3. Initializes Terraform to prepare it for the deployment.
   
4. Validates the Terraform configuration to ensure it is error-free.

5. Generates an execution plan that outlines the changes Terraform will make to the infrastructure.

6. Applies the execution plan to provision the AWS resources.
 
7. Environment Variables:
    - AWS_ACCESS_KEY_ID: This is the AWS access key ID that Terraform will use to authenticate with AWS.
    - AWS_SECRET_ACCESS_KEY: This is the AWS secret access key that Terraform will use to authenticate with AWS.

Jobs:
The workflow consists of one job named build-infrastructure. This job runs on an Ubuntu-latest runner and performs all the steps involved in the deployment process.

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/03e7ada5-a649-4b68-bf86-122c433b190d)

After merging the feature branch into the main branch the pipeline will run automatically as we have mentioned in the deploy.yaml

![image](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/cd5837dc-c872-44e6-9cbc-9eec046d5537)

AWS console the resources that we mentioned in the terraform files have been created. 
Here is the completed web application now live on the EC2 instance, accessible through the ALB URL. Additionally, the ALB is actively managing the traffic by seamlessly switching between two EC2 instances.

![Screenshot 2023-11-11 221716](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/2f436f23-6d20-487d-a492-a7cb5ae0b490)

![Screenshot 2023-11-11 221659](https://github.com/rohansjadhav/terraform-aws-github-actions-Project/assets/149859730/1179ca70-f7ea-474c-9119-7a58f9f72024)




