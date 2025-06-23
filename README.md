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


## 🌐 What is Terraform Cloud?

**Terraform Cloud** is a managed service by HashiCorp that provides:
- Remote **Terraform state management**
- **Version control** integration (GitHub, GitLab, etc.)
- **Team collaboration**
- **Access controls**, **Policy as Code**, and **Audit logs**

- Instead of running Terraform only on your laptop,
you can use Terraform Cloud to:

   - Save the plan & apply history

   - Share your setup with a team

   - Auto-deploy infra when you push code to GitHub
 
# What is a Project in Terraform Cloud?

In Terraform Cloud, a Project is a way to group related workspaces together.


   -  Organize workspaces by application, team, or environment

   -  Apply access controls and policies at the project level

   -  Keep things clean and structured

# Terraform Workspace

A Terraform Workspace is an isolated environment in Terraform that keeps a separate state file for each environment (like dev, stage, prod), using the same Terraform code.

🧠 Think of it like:

  One codebase, but

  Different environments, each with their own infrastructure


📦 In Terraform Cloud, Each workspace consists its own :

  - State file

  - Terraform run history

  - Set of variables

# 🌐 Multi-Provider Setup in Terraform

## 🧠 What is Multi-Provider in Terraform?

Terraform supports **multi-provider configurations**, allowing you to manage infrastructure across **different cloud platforms** (like AWS, Azure, GCP) or multiple instances of the same provider in **one unified setup**.

This means you can define resources from **multiple clouds in a single `.tf` file**, enabling true hybrid or multi-cloud deployments.

---

## ✅ Benefits of Multi-Provider Setup

### 🔁 1. Hybrid Cloud Deployments
You can provision infrastructure on **AWS**, **Azure**, and other platforms at the same time — perfect for companies using **hybrid or multi-cloud** strategies.

### ⚙️ 2. Unified Automation
Centralizes your **Infrastructure as Code (IaC)** workflows for all providers. This means fewer tools and better control over deployments.

### 🔗 3. Cross-Provider Integrations
Enables scenarios like:
- Host compute on Azure, but manage DNS on AWS Route 53
- Use Azure Blob for backup, while deploying on AWS EC2

### ♻️ 4. Reuse Across Environments
You can replicate the same architecture in different cloud environments easily by just switching providers or aliases.

---
# 🔐 Secret Management in Terraform

Terraform often interacts with cloud providers and services that require sensitive credentials such as API keys, passwords, and tokens. Proper secret management is crucial to avoid exposing these credentials in source control or logs.

---

## ❓ What is Secret Management?

**Secret Management** in Terraform refers to securely handling and storing sensitive data used during infrastructure provisioning — such as:

- API keys
- Database passwords
- Access tokens
- Private keys

---

## ⚠️ Why is it Important?

- Terraform **stores secrets in plain text** inside the `.tfstate` file.
- If mishandled, secrets can be **accidentally committed to Git** or **leaked in logs**.
- Secure secret management helps ensure:
  - 🔒 Data confidentiality
  - ✅ Compliance with security standards
  - 🛡️ Reduced risk of breaches

---

## ✅ Ways to Manage Secrets in Terraform

### 1. Environment Variables

Store secrets as environment variables in your shell or CI/CD pipeline.

```bash
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="SECRET"
terraform apply
```
### 2. Sensitive Variables in Terraform
Mark variables as sensitive in variables.tf:
```
variable "db_password" {
  type      = string
  sensitive = true
}
```
Pass values via CLI, environment, or .tfvars file:
```
db_password = "mysecret"
```
Pros: Reduces exposure in terraform plan output
Cons: Still saved in plain text inside terraform.tfstate

### 4. External Secret Managers

a) AWS Secrets Manager

b) HashiCorp Vault

Integrate Vault as a backend or external provider for retrieving secrets securely.

 c) Azure Key Vault 

# 🛡️ HashiCorp Vault with Terraform - Practical Demo

## 📌 Objectives

- Understand how Vault stores and manages secrets
- Access Vault secrets using Terraform's `vault` provider
- Use secrets in real-time to configure the AWS provider

## 🚀 Step-by-Step Setup

- 1️⃣ Start Vault in Dev Mode

> ⚠️ Dev mode is for testing only.

```bash
vault server -dev
```
- Copy the Root Token shown in the terminal
  
# 2️⃣ Configure Vault CLI in a New Terminal

```
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='your-root-token-here'
```
- Test the Vault
```
vault status
```
# 3️⃣ Store a Secret in Vault

```
vault kv put secret/aws-creds access_key="your-access-key-id" secret_key="your-secret-key-id"

```
## ✅ What is a Terraform Module?

A **Terraform module** is a folder containing `.tf` files that group related infrastructure resources.

Modules help you:
- Avoid repeating the same code
- Organize your Terraform project
- Make infrastructure reusable and scalable

---

# 🧰 Use Cases of Terraform Modules

| Use Case                        | Description                                                                                         |
| ------------------------------- | --------------------------------------------------------------------------------------------------- |
| ✅ **Reuse Infra Code**          | Reuse the same code for creating VPCs, EC2s, DBs, etc. in different environments (dev/staging/prod) |
| ✅ **Standardize Resources**     | Enforce consistency across your team’s infrastructure                                               |
| ✅ **Simplify Complex Projects** | Break big configurations into smaller, manageable parts                                             |
| ✅ **Multi-Environment Setup**   | Deploy same infra in `us-east-1`, `ap-south-1`, etc., with different values                         |
| ✅ **Team Collaboration**        | Share modules across projects and teams easily                                                      |
| ✅ **Third-Party Integration**   | Use verified community modules from Terraform Registry                                              |


# 🧱 Types of Terraform Modules
Terraform has 2 core categories of modules and some subtypes based on where they come from:

1️⃣ Root Module

  - The main Terraform configuration you run (main.tf, variables.tf, etc.).

  - Located in your working directory.

  - Every Terraform project has one root module.

    
Example
```
project/
├── main.tf         # Root module
├── variables.tf
└── outputs.tf
```
2️⃣ Child Module

  - A module called from the root module (or from another module).
  - Can be local or remote.
  - Helps split infra into reusable parts.

```
module "vpc" {
  source = "./modules/vpc"  # Child module
}
```

📦 Based on Location of Child Modules

a) Local Modules

  - Located inside your own project directory.
  - Source path is a folder.
```
module "vpc" {
  source = "./modules/vpc"
}
```

b) Remote Modules

 - Downloaded from Terraform Registry, GitHub, Bitbucket, or private Git repos.

🌐 Example – from Terraform Registry:
```
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
}
```
📁 Example – from GitHub:
```
module "vpc" {
  source = "git::https://github.com/bhuvan-raj/my-vpc-module.git"
}
```
c) Published Modules (Reusable by Teams or Community)

  - Modules written, versioned, and shared in a central location (like Terraform Registry or private Git).

  - Often follow naming standards like terraform-<PROVIDER>-<NAME>.



# count in Terraform

## ✅ What is it?

count is used to create multiple instances of a resource or module by simply specifying the number of copies you want to make.

 Syntax:
 ```
 resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0abcd1234abcd5678"
  instance_type = "t2.micro"
}
```
This will create:

  - aws_instance.web[0]

  - aws_instance.web[1]

  - aws_instance.web[2]

## count.index

Inside the block, you can use count.index to access the current index (starting from 0):
```
tags = {
  Name = "server-${count.index}"
}
```
## ✅ When to Use count:

  - When you want to create N identical resources

  - When iterating over a simple list

  - When the order matters, not the names

 ⚠️ Limitations of count:

   - You access elements only by numeric index

   - If the list order changes, Terraform might destroy and recreate resources

   - No named reference — only index-based

# for_each in Terraform

## What is it?

for_each is used to create multiple named instances of a resource or module using a map or set of strings. Each resource instance is identified by a key.

Syntax with Map:
```
variable "servers" {
  default = {
    server1 = "t2.micro"
    server2 = "t2.small"
  }
}

resource "aws_instance" "web" {
  for_each = var.servers

  ami           = "ami-0abcd1234abcd5678"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
```
This creates:

  - aws_instance.web["server1"]

  - aws_instance.web["server2"]


each.key & each.value

- each.key: Key from the map (e.g., "server1")

- each.value: Value from the map (e.g., "t2.micro")

## When to Use for_each:

  - When dealing with named resources (map or set)

  - When you want more control over identity (e.g., server1, server2)

  - When you want to avoid re-creating everything on data structure change (safer than count)

## Comparison between count and for_each

| Feature            | `count`                       | `for_each`               |
| ------------------ | ----------------------------- | ------------------------ |
| Input Type         | Integer / List                | Map or Set               |
| Accessing Elements | `count.index`                 | `each.key`, `each.value` |
| Identifier Type    | Numeric Index                 | Named Key                |
| Resource Address   | `resource[0]`                 | `resource["name"]`       |
| Best For           | Simple duplication            | Unique named resources   |
| Limitation         | Can cause resource recreation | Requires map/set input   |



Best Practices:

  Use count when:

   - You need a fixed number of similar resources.

   - You don’t care about naming each one uniquely.

  Use for_each when:

   - You want more readable & stable resource references.

   - You are working with maps or sets.

   - You want to avoid resource destruction when order changes.











