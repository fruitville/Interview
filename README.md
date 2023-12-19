# Terraform Infrastructure as Code (IaC) Interview Assignment

## Overview

Terraform project to create a AWS infrastructure with:

- Virtual Private Cloud (VPC)
- Public and Private Subnets
- Internet Gateway (IGW)
- Route Tables
- EC2 Instances (Web Server and Database Server)

## Repository Structure

- **main.tf**: Main Terraform configuration file specifying the AWS resources to be provisioned.
- **variables.tf**: Variable definitions for customization and parameterization.
- **terraform.tfvars**: Variable values specific to your environment (not included in the repository for security reasons).
- **README.md**: Documentation providing an overview, setup instructions, and any additional information.

## Setup Blueprint

1. **Created Repository:**
ssh:  git@github.com:fruitville/Interview.git

**#Created a directory**

mkdir project-terraform
cd project-terraform

**#Initialized terraform**

terraform init

**#Created Variables:**

Open variables.tf to customize the variables as needed.

**#Created Terraform Configuration:**

Open main.tf to see the defined infrastructure.

**#Executed Terraform Plan:**

terraform plan

**#Applied Changes:**

terraform apply

**#Listed resources created by Terraform**

terraform state list

**#Destroy Resources (At a later time):**

terraform destroy

**#InitializeD the directory (created local git repository)**
git init

**#Added terraform files.**
git add *.tf

git commit -m "Added terraform files"

git remote add origin git@github.com:fruitville/Interview.git

**#pushed code into GitHub**
git push -u origin master

CHALLENGES
Had issues uploading tf files, because I had not created ssh-keys and uploaded into GitHub. 
solved this problem with the code below

ssh-keygen

sudo cat ~/.ssh/id_rsa.pub


