

# Core Terraform Blocks

Terraform configurations are written in **HashiCorp Configuration Language (HCL)** and are composed of multiple **blocks**, each serving a specific purpose.

---

## 1. `terraform` Block

### What is the Terraform Block?

The `terraform` block is a **meta-configuration block**. It does **not create infrastructure**, but it defines **how Terraform itself should behave**.

Think of it as the **project configuration block**.

---

### What the `terraform` Block Is Used For

The `terraform` block is commonly used to:

* Declare **required Terraform version**
* Declare **required providers**
* Configure **remote backends** for state storage
* Enable Terraform features (like experiments in older versions)

---

### Basic Example

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

### Backend Configuration Example

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "prod/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

---

### Key Points About `terraform` Block

* Only **one `terraform` block** is needed per project (multiple are allowed but merged)
* Executed **before any provider or resource**
* Mandatory for real-world projects
* Does not support variables directly (except via `-backend-config`)

---

## 2. `provider` Block

### What is a Provider Block?

A `provider` block configures **how Terraform connects to a specific platform or service**.

Providers are responsible for **authentication**, **region selection**, and **API interaction**.

---

### What the `provider` Block Does

* Defines **credentials**
* Sets **region / endpoint**
* Controls provider-specific behavior
* Enables **multi-region and multi-account** setups using aliases

---

### Example: AWS Provider

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

Terraform automatically loads credentials from:

* Environment variables
* `~/.aws/credentials`
* IAM role (for EC2 / EKS)

---


### Key Points About `provider` Block

* Required for every platform Terraform manages
* Multiple provider blocks allowed uisng alias
* Provider configuration is **separate from provider installation**
* Providers are downloaded during `terraform init`

---

## 3. `resource` Block

### What is a Resource Block?

A `resource` block defines **actual infrastructure components**.

This is the block that **creates, updates, and deletes real resources** in the cloud or service.

---

### Resource Block Syntax

```hcl
resource "<PROVIDER>_<RESOURCE_TYPE>" "<NAME>" {
  argument = value
}
```

---

### Example: AWS EC2 Instance

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0abcdef123"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
  }
}
```

---

### Resource Naming Explained

```text
aws_instance.web
│   │        │
│   │        └── Logical name (used internally by Terraform)
│   └──────── Resource type
└──────────── Provider
```

---

### Resource Lifecycle

Terraform tracks resources using:

* Configuration files
* Provider API
* Terraform state file

Terraform decides:

* **Create** → new resource
* **Update** → modify existing resource
* **Destroy** → remove resource

---

### Resource Meta-Arguments

Common meta-arguments:

```hcl
count
for_each
depends_on
provider
lifecycle
```

Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

---

## `.terraform/` Directory

### What is `.terraform/`?

`.terraform/` is a **local working directory** created by Terraform during `terraform init`.

---

### What It Contains

* Downloaded **provider plugins**
* Downloaded **modules**
* Backend initialization data
* Cached metadata

---

### Important Notes

* It is **auto-generated**
* Should **never be modified manually**
* Should be added to `.gitignore`

Example:

```gitignore
.terraform/
```

---

## `.terraform.lock.hcl`

### What is `.terraform.lock.hcl`?

`.terraform.lock.hcl` is the **dependency lock file** for Terraform providers.

It ensures **consistent provider versions** across environments.

---

### What It Stores

* Exact provider versions used
* Checksums for provider binaries
* Provider source addresses

---

### Example Snippet

```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.31.0"
  constraints = "~> 5.0"
  hashes = [
    "h1:abcdef...",
  ]
}
```

---

### Why It’s Important

* Prevents accidental provider upgrades
* Ensures consistency across team members and CI/CD
* Similar to `package-lock.json` or `poetry.lock`

---

### Best Practices

* ✅ Commit `.terraform.lock.hcl` to Git
* ❌ Do not commit `.terraform/`
* Regenerate lock file using:

```bash
terraform init -upgrade
```

---

## Relationship Between Components

```text
terraform block → defines project & providers
provider block  → configures API access
resource block  → creates infrastructure
```

---

## Interview-Ready Summary

* `terraform` block controls Terraform behavior and dependencies
* `provider` block configures authentication and target platform
* `resource` block defines actual infrastructure
* `.terraform/` stores downloaded plugins and metadata
* `.terraform.lock.hcl` locks provider versions for consistency
