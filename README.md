# Terraform-IAC
# 📘 Terraform + AWS: Introduction to Infrastructure as Code (IaC)

## 🔧 What is IaC (Infrastructure as Code)?

Infrastructure as Code is the practice of managing and provisioning infrastructure using code instead of manual processes. It allows you to define, deploy, and manage infrastructure using configuration files.

### ✅ **Advantages of IaC:**

* **Consistency:** Reduces human errors and configuration drift.
* **Automation:** Enables automated deployments.
* **Version Control:** Track changes and rollback using Git.
* **Scalability:** Easily replicate environments.
* **Speed:** Faster provisioning of infrastructure.

## 🛠️ Popular IaC Tools

* **Terraform** (by HashiCorp) ✅
* AWS CloudFormation
* Azure Resource Manager
* Pulumi
* Chef / Puppet

## 🌍 What is Terraform?

Terraform is an open-source IaC tool developed by HashiCorp. It enables you to define both cloud and on-prem resources in human-readable configuration language called HCL (HashiCorp Configuration Language).

### ✅ **Advantages of Terraform:**

* Supports multiple cloud providers (AWS, Azure, GCP, etc.)
* Declarative language (HCL)
* Open-source and extensible
* State management
* Modular and reusable

---

## ⚙️ Setting Up Terraform with AWS

### 1. **Install Terraform CLI**

* Download from: [https://www.terraform.io/downloads](https://www.terraform.io/downloads)
* Verify: `terraform -v`

### 2. **Install AWS CLI and Configure**

* Download from: [https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
* Configure:

```bash
aws configure
```

Enter AWS Access Key, Secret Key, Region, and Output format.

### 3. **Install VS Code**

* Download from: [https://code.visualstudio.com/](https://code.visualstudio.com/)

### 4. **Install Terraform Extension for VS Code**

* Search for "HashiCorp Terraform" in extensions
* Install for syntax highlighting, formatting, and IntelliSense

---

## 🧪 Basic Terraform CLI Commands

| Command              | Description                                                    |
| -------------------- | -------------------------------------------------------------- |
| `terraform init`     | Initializes working directory and downloads required providers |
| `terraform plan`     | Shows what actions Terraform will take without applying them   |
| `terraform apply`    | Applies the configuration and creates the infrastructure       |
| `terraform destroy`  | Destroys all resources defined in the configuration            |
| `terraform validate` | Validates Terraform files syntax                               |
| `terraform fmt`      | Formats Terraform code                                         |
| `terraform state`    | Interact with the Terraform state                              |

---

## 🌐 Types of Terraform Providers

1. **Official Providers** – Maintained by HashiCorp (e.g., AWS, Azure, Google)
2. **Partner Providers** – Maintained by technology partners (e.g., Datadog, Kubernetes)
3. **Community Providers** – Maintained by the open-source community

---

## 🧱 Types of Terraform Configuration Blocks

| Block      | Purpose                                        |
| ---------- | ---------------------------------------------- |
| `provider` | Defines cloud provider details                 |
| `resource` | Describes infrastructure to create             |
| `variable` | Accepts dynamic input from user                |
| `output`   | Displays values after apply                    |
| `module`   | Groups reusable Terraform code                 |
| `data`     | Reads existing external data                   |
| `locals`   | Defines local variables within a configuration |

---

## 🚀 What Happens When You Run `terraform init`?

* Downloads the provider plugins
* Initializes backend configuration (if any)
* Prepares the working directory for other commands

## ⚙️ What Happens During `terraform apply`?

* Reads current infrastructure state
* Compares it with desired state (defined in code)
* Plans changes
* Applies the changes
* Updates the state file

---
# terraform block
* This block configures settings for Terraform itself.
* You can specify the required Terraform version

```
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Where to download the provider from
      version = "~> 5.0"         # Acceptable version constraint
    }
  }
}
```
# provider block
* The provider block defines which cloud/service provider
* Terraform should use, and how to connect to it.
* You can configure region, credentials, and more.
```
provider "aws" {
  region = "us-east-1"  # AWS region where resources will be created
}
```
# resource block

* A resource block defines the actual infrastructure to create.
* It includes the resource type, a local name, and its properties.
```
resource "aws_instance" "example" {
   ami_id = "ami-id"
   instance_type = "instance-type"
```
## 🔐 What is `.terraform.lock.hcl`?

* Locks the provider versions used in your project
* Ensures consistent and reproducible builds
* Created during `terraform init`

## 📁 What is Backend in Terraform?

A backend defines **where Terraform stores its state file**.

### Common backends:

* Local (default)
* AWS S3 (with optional DynamoDB for state locking)
* Terraform Cloud
* Remote HTTP backends

---
Explicit Local Backend

```
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```
S3 Backend 
```
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"  # Your S3 bucket name
    key            = "env/dev/terraform.tfstate"  # Path inside the bucket
    region         = "us-east-1"                  # Region of the bucket
    dynamodb_table = "terraform-lock-table"       # Optional: for state locking
    encrypt        = true                         # Enable SSE encryption
  }
}
```

## 🧾 What is State File (`terraform.tfstate`)?

* Tracks the current state of infrastructure
* Required for Terraform to determine changes

### Types of State:

* **Local state** – Stored in your working directory
* **Remote state** – Stored in a remote backend (e.g., S3, Terraform Cloud)

---

##  What is Terraform State File Lock?

Terraform uses a file called `terraform.tfstate` to store the current state of your infrastructure.  
When multiple people or systems run `terraform apply` at the same time, it can corrupt this state.

To prevent this, **Terraform locks the state file** during operations like `plan` and `apply`.

###  State Locking in Practice

- When Terraform begins an operation, it **locks** the state.
- If another process tries to make changes while it's locked, it will wait or fail.
- When the operation finishes, the lock is **released**.

> If you're using **remote backends** like S3 with DynamoDB, the lock is managed automatically using DynamoDB as a lock table.

---

## 📌 What is a Data Block in Terraform?

A `data` block is used to **fetch or reference existing resources** in your cloud account **without creating them**.

### 🧠 Use Case

You might have an existing VPC in AWS that was created manually or by another team. Instead of recreating it, you **reference it using a `data` block** and then build your resources (like subnets, EC2) inside it.

---
```
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["test-vpc"]  # Replace with the actual Name tag of your VPC
  }
}
```


# 📤 Terraform Output Block

## 🔍 What is an Output Block?

An `output` block in Terraform is used to **display values** after your infrastructure is provisioned. It helps you see important resource attributes like:

- Public IPs of EC2 instances
- Names of created buckets
- IDs of subnets or VPCs

---

## 🎯 Why Use Output Blocks?

- ✅ View useful resource info in the terminal
- ✅ Share values between modules
- ✅ Export outputs for use in automation or scripts

---

## 🧾 Syntax

```hcl
output "name" {
  description = "Description of the output"
  value       = <expression>
  sensitive   = false  # optional
}
````

---

## 📘 Example

```hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}
```

---

## 🖥️ Output After `terraform apply`

```
Outputs:

instance_public_ip = "3.91.24.77"
```

---

## 📚 More Info

* [Terraform Output Documentation](https://developer.hashicorp.com/terraform/language/values/outputs)


## 📌 What Are Terraform Variables?

Terraform **variables** are placeholders used to make your code **reusable**, **dynamic**, and **clean**. They allow you to:

- Avoid hardcoding values
- Easily change configurations across environments
- Reuse modules and scripts with different inputs

---

## 📦 Why Use Variables?

Using variables:
- Makes your code modular
- Helps in managing different environments (dev, staging, prod)
- Makes automation easier (e.g., using CI/CD pipelines)

---

## 📁 Recommended File Structure

- main.tf     - Defines the actual resources (e.g., EC2, VPC)
- variables.tf   - Declares all the input variables with type, description, etc.
- terraform.tfvars -  Provides actual values for the declared variables
- outputs.tf (optional)  -  Defines outputs from the resources


