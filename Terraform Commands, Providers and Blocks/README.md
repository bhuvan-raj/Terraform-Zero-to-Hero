
# Terraform Commands

Terraform commands are executed using the `terraform` CLI and are used to **initialize**, **validate**, **plan**, **apply**, **format**, and **destroy** infrastructure defined using Terraform configuration files (`.tf`).

---

## 1. `terraform init`

### Purpose

Initializes a Terraform working directory. This is the **first command** you must run in any Terraform project.

### What it does internally

* Downloads the **required provider plugins** (AWS, Azure, GCP, etc.)
* Initializes the **backend** (local, S3, Terraform Cloud, etc.)
* Downloads and configures **Terraform modules**
* Creates the `.terraform/` directory

### Key points

* Must be run **once per project** or whenever:

  * You add/change providers
  * You change backend configuration
  * You add modules
* Safe to run multiple times

### Example

```bash
terraform init
```

### Common options

```bash
terraform init -upgrade   # Upgrade providers and modules
terraform init -reconfigure  # Reinitialize backend
```

---

## 2. `terraform validate`

### Purpose

Checks whether the Terraform configuration files are **syntactically correct** and **logically valid**.

### What it checks

* Correct Terraform syntax
* Proper usage of blocks (`resource`, `provider`, `variable`, etc.)
* Missing required arguments
* Invalid references

### What it does NOT check

* Does not check cloud-side errors
* Does not create or modify any resources

### When to use

* After writing or modifying `.tf` files
* In CI/CD pipelines for early error detection

### Example

```bash
terraform validate
```

---

## 3. `terraform fmt`

### Purpose

Automatically formats Terraform configuration files to follow **standard Terraform style**.

### What it does

* Aligns indentation
* Orders arguments properly
* Improves readability and consistency

### Why it’s important

* Makes code clean and professional
* Enforces consistency across teams
* Often mandatory in real projects and CI pipelines

### Example

```bash
terraform fmt
```

### Recursive formatting

```bash
terraform fmt -recursive
```

---

## 4. `terraform plan`

### Purpose

Creates an **execution plan** showing what Terraform *will* do before actually doing it.

### What it shows

* Resources to be **created**
* Resources to be **updated**
* Resources to be **destroyed**
* Values that will change

### Why it’s critical

* Prevents accidental changes
* Helps review infrastructure changes safely
* Used heavily in CI/CD pipelines

### Example

```bash
terraform plan
```

### Saving a plan

```bash
terraform plan -out=tfplan
```

This saved plan can be applied later:

```bash
terraform apply tfplan
```

---

## 5. `terraform apply`

### Purpose

Applies the changes required to reach the desired infrastructure state.

### What it does

* Reads configuration files
* Compares with the current state
* Executes API calls to create/update/delete resources
* Updates the `terraform.tfstate` file

### Interactive behavior

* Shows the execution plan
* Prompts for confirmation:

  ```
  Do you want to perform these actions?
  Type "yes" to continue:
  ```

### Example

```bash
terraform apply
```

---

## 6. `terraform apply --auto-approve`

### Purpose

Applies infrastructure changes **without asking for confirmation**.

### Key use cases

* CI/CD pipelines
* Automated deployments
* Non-interactive environments

### Warning ⚠️

* Dangerous if used without proper review
* Always recommended to run `terraform plan` before using this

### Example

```bash
terraform apply --auto-approve
```

---

## 7. `terraform destroy`

### Purpose

Destroys all resources managed by the current Terraform configuration.

### What it does

* Reads the state file
* Deletes all tracked resources
* Updates the state after destruction

### Use cases

* Cleaning up test environments
* Cost optimization
* Temporary labs and demos

### Example

```bash
terraform destroy
```

### Auto-approve destroy

```bash
terraform destroy --auto-approve
```

### Important warning ⚠️

* This **permanently deletes infrastructure**
* Use lifecycle rules like `prevent_destroy` to protect critical resources

---

## Command Execution Flow (Typical)

```text
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

---

## Interview-Friendly Summary

| Command                          | Purpose                                |
| -------------------------------- | -------------------------------------- |
| `terraform init`                 | Initialize providers, backend, modules |
| `terraform validate`             | Validate syntax and configuration      |
| `terraform fmt`                  | Format Terraform files                 |
| `terraform plan`                 | Preview infrastructure changes         |
| `terraform apply`                | Create/update infrastructure           |
| `terraform apply --auto-approve` | Apply changes without confirmation     |
| `terraform destroy`              | Delete all managed resources           |

---
Alright, **Bubu** — let’s go deep and keep it **clean, interview-ready, and teaching-friendly**.

---

# Terraform Providers

A **Terraform provider** is a plugin that allows Terraform to interact with external APIs and services such as **AWS, Azure, GCP, Kubernetes, GitHub, Docker**, and many others.

Providers act as the **bridge between Terraform and real infrastructure**.

---

## What a Terraform Provider Does

A provider is responsible for:

* Authenticating with a target service
* Understanding the service’s API
* Creating, reading, updating, and deleting resources (CRUD operations)
* Exposing **resources** and **data sources** to Terraform

Without providers, Terraform cannot manage any infrastructure.

---

## How Providers Work Internally

1. Terraform reads `.tf` configuration files
2. Required providers are declared in the `required_providers` block
3. `terraform init` downloads the provider plugins
4. Terraform uses providers to:

   * Fetch data (`data` blocks)
   * Create or manage infrastructure (`resource` blocks)
5. Provider state is recorded in the Terraform state file

---

## Declaring Providers in Terraform

### Example: AWS Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

---

## Provider Source Address Format

```text
<namespace>/<provider>
```

Examples:

* `hashicorp/aws`
* `hashicorp/kubernetes`
* `integrations/github`
* `datadog/datadog`

---

## Types of Terraform Providers

Terraform providers are classified into **three main categories** based on **ownership, maintenance, and support level**.

---

# 1. Official Providers

### Definition

**Official providers** are developed, owned, and maintained by **HashiCorp** itself.

### Characteristics

* Fully supported by HashiCorp
* Follow strict quality and security standards
* Well-documented and stable
* Frequently updated
* Suitable for **production environments**

### Namespace

```text
hashicorp/<provider>
```

### Common Official Providers

* `hashicorp/aws`
* `hashicorp/azurerm`
* `hashicorp/google`
* `hashicorp/kubernetes`
* `hashicorp/docker`
* `hashicorp/vault`
* `hashicorp/consul`

### Example

```hcl
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
}
```

### When to Use

* Enterprise environments
* Mission-critical infrastructure
* Long-term projects
* When official support is required

---

# 2. Partner Providers

### Definition

**Partner providers** are developed by **third-party companies**, but officially **verified and supported** by those companies in collaboration with HashiCorp.

### Characteristics

* Maintained by technology vendors
* Verified by HashiCorp
* High quality and reliable
* Supported by the provider’s owning company
* Suitable for production use

### Namespace

```text
<company>/<provider>
```

### Common Partner Providers

* `integrations/github` – GitHub
* `datadog/datadog` – Datadog
* `mongodb/mongodbatlas` – MongoDB Atlas
* `cloudflare/cloudflare` – Cloudflare
* `snowflake-labs/snowflake` – Snowflake

### Example

```hcl
required_providers {
  github = {
    source  = "integrations/github"
    version = "~> 6.0"
  }
}
```

### When to Use

* Managing SaaS platforms
* Vendor-specific infrastructure
* Cloud services outside core cloud providers

---

# 3. Community Providers

### Definition

**Community providers** are built and maintained by **individual developers or open-source communities**, not officially verified by HashiCorp.

### Characteristics

* Open source
* May lack long-term support
* Quality and update frequency can vary
* Limited documentation
* Use with caution in production

### Namespace

```text
<username>/<provider>
```

### Examples

* `kreuzwerker/docker` (before becoming official)
* `telmate/proxmox`
* `cyrilgdn/postgresql`
* `loafoe/ssh`

### Example

```hcl
required_providers {
  proxmox = {
    source  = "telmate/proxmox"
    version = "2.9.14"
  }
}
```

### When to Use

* Labs and experiments
* Non-critical workloads
* When no official or partner provider exists

---

## Comparison Table

| Feature          | Official      | Partner        | Community               |
| ---------------- | ------------- | -------------- | ----------------------- |
| Maintained by    | HashiCorp     | Vendor company | Individuals / community |
| Namespace        | `hashicorp/*` | `company/*`    | `user/*`                |
| Verified         | ✅             | ✅              | ❌                       |
| Production ready | ✅             | ✅              | ⚠️                      |
| Support          | HashiCorp     | Vendor         | Community               |
| Documentation    | Excellent     | Very good      | Varies                  |

---

## Provider Versioning Best Practices

### Always pin provider versions

```hcl
version = "~> 5.0"
```

### Avoid

```hcl
version = ">= 1.0"
```

This prevents breaking changes during upgrades.

---

## Multiple Providers and Aliases

Used for:

* Multi-region deployments
* Multi-account setups

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}
```

Usage:

```hcl
provider = aws.mumbai
```

---

## Provider Authentication

Providers authenticate using:

* Environment variables
* Configuration blocks
* Shared credential files
* External secret managers (Vault, AWS Secrets Manager)

Example (AWS):

```bash\db
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=yyy
```

---

## 🧱 Types of Terraform Configuration Blocks (Basic Overview)

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

