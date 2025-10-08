# Terraform-IAC
<img src="https://github.com/bhuvan-raj/Terraform-Zero-to-Hero/blob/main/hashicorp-terraform-banner.png" alt="Banner" />



# 📘 Terraform + AWS: Introduction to Infrastructure as Code (IaC)


<img src="https://github.com/bhuvan-raj/Terraform-Zero-to-Hero/blob/main/aws.png" alt="Banner" />

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

## 🧱 Types of Terraform Configuration Blocks (Your Given Order)

| Block       | Purpose                                                                |
| ----------- | ---------------------------------------------------------------------- |
| `terraform` | Sets overall configuration like backend and required providers         |
| `provider`  | Specifies the cloud or service provider details (e.g., AWS, Azure)     |
| `resource`  | Defines infrastructure to be created (e.g., EC2, S3, VPC)              |
| `variable`  | Accepts dynamic input values from users                                |
| `backend`   | (Inside `terraform` block) Configures remote state storage             |
| `output`    | Displays values after `terraform apply` (like IPs, URLs, IDs)          |
| `module`    | Groups reusable Terraform code for cleaner and scalable configurations |
| `lifecycle` | (Inside `resource` block) Controls create, update, and delete behavior |

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
The most crucial part of setting up DynamoDB for Terraform state locking is ensuring the table has the correct **Partition Key** defined.

### Console Steps to Create the DynamoDB Lock Table

#### Step 1: Navigate to DynamoDB

1.  In the AWS Management Console search bar, type `DynamoDB` and select the service.
2.  In the DynamoDB console, navigate to **Tables**.

#### Step 2: Create the Table

1.  Click the orange **Create table** button.

2.  Under **Table details**, configure the following:

      * **Table name:** Choose a descriptive name. This name is what you will use in your Terraform backend configuration.

          * **Example:** `terraform-state-lock`

      * **Partition key:** This is the *most critical step*. The key name **must** be exactly:

          * **Name:** `LockID`
          * **Type:** Select **String**

      * **Sort key:** Leave this field **blank**.

3.  Under **Table settings** (for low-traffic lock tables):

      * **Capacity mode:** Select **On-demand** (recommended for low-traffic, cost-effective usage). *Alternatively*, you can choose **Provisioned** and set Read/Write capacity to a low number (like 5 units each) if you prefer predictable costs.

4.  **Tags (Optional but Recommended):**

      * Click **Add new tag** and add a tag like `Name` with the value `TerraformStateLock`.

5.  **Review and Create:**

      * Review the settings to ensure the Table Name and the `LockID` **Partition key (String type)** are correct.
      * Click the **Create table** button at the bottom.

#### Step 3: Verification

1.  After a minute or two, the table status should change from *Creating* to **Active**.
2.  Click on the new table name (`terraform-state-lock`).
3.  Under the **Details** tab, verify that the **Partition key** is listed as `LockID (String)`.

### Next Step: Configure Terraform

Once the table is **Active**, you can update your Terraform code with the remote S3 backend configuration, ensuring the `dynamodb_table` value matches the name you just created:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-state-bucket-name"
    key            = "path/to/your/statefile.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"  # MUST match the table name you created
    encrypt        = true
  }
}
```

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

That is a comprehensive set of examples for filtering the `aws_vpc` data source.


-----

### Filtering by a Custom Tag

```hcl
data "aws_vpc" "by_custom_tag" {
  filter {
    name   = "tag:Environment"
    values = ["staging"]
  }
}
```

### Filtering by CIDR Block

```hcl
data "aws_vpc" "by_cidr" {
  filter {
    name   = "cidr-block"
    values = ["10.1.0.0/16"]
  }
}
```

### Filtering by State

```hcl
data "aws_vpc" "by_state" {
  filter {
    name   = "state"
    values = ["available"]
  }
}
```

### Filtering for the Default VPC

```hcl
data "aws_vpc" "default" {
  default = true
}

# NOTE: You can also use a filter block for this:
/*
data "aws_vpc" "default_filter" {
  filter {
    name   = "is-default"
    values = ["true"]
  }
}
*/
```

### Combining Filters (AND Logic)

```hcl
data "aws_vpc" "combined_filter" {
  # Filter 1: VPC must have this tag
  filter {
    name   = "tag:Project"
    values = ["backend"]
  }

  # Filter 2: AND the VPC must have this CIDR block
  filter {
    name   = "cidr-block"
    values = ["10.5.0.0/16"]
  }
}
```

### Filtering by Tags (and Outputting the ID)

```hcl
data "aws_vpc" "by_name" {
  filter {
    name   = "tag:Name"            # The name of the tag key
    values = ["production-vpc-1"]  # The value of the tag key
  }
}

output "vpc_id_by_name" {
  value = data.aws_vpc.by_name.id
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
    

# Introduction to Terraform Variables

Variables in Terraform allow you to **parameterize your configurations**. Instead of hardcoding values (like AMI IDs, instance sizes, or region names), you can use variables to make your Terraform code **dynamic, reusable, and environment-agnostic**.

Think of variables as **placeholders** that get their values at runtime.

---

## **2. Benefits of Using Variables**

* **Reusability:** One configuration can be used in multiple environments (dev, staging, prod) just by changing variable values.
* **Readability:** Makes configuration cleaner by avoiding hardcoded values.
* **Security:** Sensitive information like passwords or API keys can be passed as variables instead of being hardcoded.
* **Flexibility:** Easy to override values without editing Terraform code.

---

## **3. Types of Terraform Variables**

Terraform supports different types of variables:

### **a. String**

Represents textual data.

```hcl
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
```

### **b. Number**

Represents numeric values.

```hcl
variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 2
}
```

### **c. Boolean**

Represents true/false values.

```hcl
variable "enable_monitoring" {
  description = "Enable monitoring for EC2"
  type        = bool
  default     = true
}
```

### **d. List (or Tuple)**

Represents an ordered sequence of values.

```hcl
variable "availability_zones" {
  description = "List of AZs to deploy"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
```

### **e. Map (or Object)**

Represents key-value pairs.

```hcl
variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {
    Environment = "dev"
    Owner       = "Bubu"
  }
}
```

---

## How to Set Variable Values**

Terraform variables can be set in **multiple ways**:

### **a. Default Values**

Use the `default` argument in variable block. Example:

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

### **b. CLI Input**

Use `-var` when running Terraform commands:

```bash
terraform apply -var="instance_type=t3.medium"
```

### **c. Variable Files (`.tfvars`)**

Create a file, e.g., `terraform.tfvars` or `prod.tfvars`:

```hcl
region        = "us-west-2"
instance_type = "t3.micro"
```

Apply with:

```bash
terraform apply -var-file="prod.tfvars"
```


### ** Prompt During Apply**

If no default is set and no value is provided, Terraform will **prompt the user**:

```hcl
variable "project_name" {
  description = "Name of the project"
}
```

Terraform will ask:

```
Enter a value: 
```

---

## ** Sensitive Variables**

For sensitive information (passwords, API keys):

```hcl
variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}
```

Sensitive variables will **not be shown in Terraform logs or outputs**.

---

## **7. Using Variables in Terraform Code**

Variables are accessed using the `var` keyword:

```hcl
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
}
```

---

## **8. Best Practices**

1. **Use `.tfvars` files** for environment-specific values.
2. **Avoid hardcoding sensitive data**; use `sensitive = true` or a secret manager.
3. **Provide defaults** where applicable to reduce prompts.
4. **Use descriptive names** for clarity (`db_username` is better than `user`).
5. **Validate variables** to prevent invalid inputs.
6. **Consistent variable naming** across modules.

---


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


# 🧱 Step 1: start the server

Run this in your Vault CLI or terminal:

```bash
vault server -dev
```

---

# 🗝️ Step 2: Store AWS credentials in Vault



```bash
vault kv put secret/aws-creds access_key="YOUR_AWS_ACCESS_KEY_ID" secret_key="YOUR_AWS_SECRET_ACCESS_KEY"
```

To verify:

```bash
vault kv get secret/aws-creds
```

Expected output:

```
====== Data ======
Key          Value
---          -----
access_key   YOUR_AWS_ACCESS_KEY_ID
secret_key   YOUR_AWS_SECRET_ACCESS_KEY
```

---

# 🔐 Step 3: Create a Vault token for Terraform

Terraform needs a Vault token (with read access) to fetch secrets.

Create a **policy** that allows read-only access to that path:

**vault-policy.hcl**

```hcl
path "secret/data/aws-creds" {
  capabilities = ["read"]
}
path "auth/token/create" {
  capabilities = ["update"]
}
```

Apply the policy:

```bash
vault policy write terraform-policy vault-policy.hcl
```

Create a token tied to that policy:

```bash
vault token create -policy=terraform-policy
```

Copy the `token` value — you’ll use it in Terraform as `VAULT_TOKEN`.

---

# 🏗️ Step 4: Configure Terraform to use Vault provider

Create a Terraform file, e.g. **vault.tf**:

```hcl
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}
```

---

# 🗃️ Step 5: Fetch secrets from Vault

Now create a data block to read your AWS credentials:

```hcl
data "vault_kv_secret_v2" "aws_creds" {
  mount = "secret"
  name  = "aws-creds"
}
```

---

# 🧩 Step 6: Use those secrets in AWS provider

Now you can inject the Vault values into the AWS provider configuration:

```hcl
provider "aws" {
  region     = "ap-south-1"
  access_key = data.vault_kv_secret_v2.aws_creds.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]
}
```


# 🧪 Step 8: Initialize and Apply

```bash
terraform init
terraform plan
terraform apply
```

Terraform will:

1. Connect to Vault using your token
2. Read `access_key` and `secret_key` from `secret/aws-creds`
3. Use those creds to authenticate with AWS

---

# 🧠 Recap of Flow

| Step | Action                   | Component       |
| ---- | ------------------------ | --------------- |
| 1    | Enable KV engine         | Vault           |
| 2    | Store AWS creds          | Vault           |
| 3    | Create policy & token    | Vault           |
| 4    | Configure Vault provider | Terraform       |
| 5    | Fetch secrets            | Terraform       |
| 6    | Use in AWS provider      | Terraform       |
| 7    | Apply Terraform plan     | Terraform + AWS |

---

# ⚠️ Best Practices

✅ Never hardcode AWS credentials in `.tf` files
✅ Use short-lived Vault tokens
✅ Use **Vault Agent** or **AppRole Auth Method** for automation (next level)
✅ Store your Vault address and token as environment variables

---

Would you like me to show you how to do the **AppRole authentication method** (so Terraform doesn’t need a static Vault token)?
That’s the **production-grade setup**.


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




# 🛰️ Import Existing AWS EC2 Instance into Terraform



###  Create the `main.tf` File

```hcl
provider "aws" {
  region = "us-east-1"  
}

resource "aws_instance" "my_imported_instance" {
  # Placeholder block for import
}
```

###  Initialize Terraform

```bash
terraform init
```

---

###  Import the Existing EC2 Instance

```bash
terraform import aws_instance.my_imported_instance i-0123456789abcdef0(instance_id)
```


###  View the Imported State

```bash
terraform show
```

```bash
terraform show -no-color > instance_raw.tf
```

---



###  Run `terraform plan`

```bash
terraform plan
```

You should see:

```
No changes. Infrastructure is up-to-date.
```

---


## 🧩 Example Resources You Can Import

```bash
terraform import aws_s3_bucket.my_bucket my-existing-bucket
terraform import aws_security_group.my_sg sg-0abc12345678def90
terraform import aws_vpc.my_vpc vpc-0123456789abcdef0
```


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


each.key & each.value

- each.key: Key from the map (e.g., "server1")

- each.value: Value from the map (e.g., "t2.micro")

## Without declaring variables (hardcoded example):

```
resource "aws_instance" "example" {
  for_each = {
    vm1 = "t2.micro"
    vm2 = "t3.micro"
  }

  ami           = "ami-12345678"
  instance_type = each.value
  tags = {
    Name = each.key
  }
}
```
Here for_each uses a local map directly. No variables used.



### With variables (recommended for reusability):
```
variable "instances" {
  type = map(string)
  default = {
    vm1 = "t2.micro"
    vm2 = "t3.micro"
  }
}

resource "aws_instance" "example" {
  for_each = var.instances

  ami           = "ami-12345678"
  instance_type = each.value
  tags = {
    Name = each.key
  }
}

```





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


#  What is `lifecycle` in Terraform?

The `lifecycle` block in a Terraform resource is used to customize specific behaviors related to:

* Resource creation
* Resource destruction
* Ignoring changes to certain attributes

It provides finer control over Terraform’s **default resource management behavior**.

---

## 🔍 Lifecycle Meta-Arguments

## 1. `create_before_destroy`

* Forces Terraform to create the **new resource before** destroying the old one.
* Useful when destruction of a resource before replacement would cause **downtime** or **data loss**.

```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

### 2. `prevent_destroy`

* Prevents Terraform from **accidentally destroying** a resource.
* Apply will **fail** with an error if destruction is attempted.

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-important-bucket"

  lifecycle {
    prevent_destroy = true
  }
}
```

### 3. `ignore_changes`

* Tells Terraform to **ignore specific attribute changes**, even if they differ from the config.
* Useful when values are managed **outside of Terraform**.

```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  tags = {
    Name = "MyEC2"
  }

  lifecycle {
    ignore_changes = [
      tags["Name"]
    ]
  }
}
```

---

## ⚠️ Best Practices

* Use `prevent_destroy` for **critical infrastructure** like production databases or storage buckets.
* Be cautious with `ignore_changes` — it can lead to **configuration drift**.
* Prefer `create_before_destroy` when **downtime is not acceptable**.







## 📖 What is `depends_on`?

In Terraform, resources usually have **implicit dependencies**. For example, if Resource A uses an attribute from Resource B, Terraform knows to create B before A.

However, sometimes you need to explicitly define dependencies. That’s where `depends_on` is used.

```hcl
resource "resource_type" "example" {
  depends_on = [resource.resource_type.other]
}
```

---

## 🧠 Why Use `depends_on`?

* To enforce creation/destruction **order** between resources
* When Terraform **cannot automatically infer** a dependency
* To avoid **race conditions** or failed builds

---

## 🧪 Simple Example: EC2 Instance that Depends on IAM Role

```hcl
resource "aws_iam_role" "example" {
  name = "my-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  depends_on = [aws_iam_role.example]
}
```

##  Terraform Taint & Untaint: Forcing Resource Recreation

In some situations, you may want to **force Terraform to destroy and recreate** a resource even if its configuration hasn’t changed. This is where `terraform taint` and `terraform untaint` come in.

---

###  `terraform taint`

Marks a specific resource as **tainted**, which means Terraform will destroy and recreate it during the next `terraform apply`.

#### Use Case:

* A resource is behaving unexpectedly (e.g., a faulty EC2 instance).
* You want to recreate it from scratch without changing any code.

#### Example:

```bash
terraform taint aws_instance.my_vm
```

> This will mark the `aws_instance.my_vm` resource for recreation.

---

### `terraform untaint`

Removes the **tainted** status from a resource, canceling the planned recreation.

####  Use Case:

* You tainted a resource by mistake and want to keep it.
* You fixed the issue manually and no longer need to recreate the resource.

#### Example:

```bash
terraform untaint aws_instance.my_vm
```

> This will remove the taint mark from `aws_instance.my_vm`.

---

###Notes:

* Tainting doesn’t immediately destroy the resource — it only flags it.
* The actual destroy-and-recreate happens on the next `terraform apply`.
* You can view the taint status by running:

```bash
terraform plan
```
