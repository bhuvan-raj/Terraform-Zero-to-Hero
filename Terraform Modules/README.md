

# Terraform Modules

## ✅ What is a Terraform Module?

A **Terraform module** is a directory (folder) that contains one or more `.tf` files and represents a **logical grouping of infrastructure resources** that are managed together.

In simple terms:

> **A module = reusable Terraform code**

Terraform itself treats **every configuration as a module**. Even the files in your current working directory are considered a module (called the *root module*).

### Why Modules Exist

Modules allow you to:

* Avoid repeating the same Terraform code
* Structure large infrastructure cleanly
* Reuse infrastructure patterns across environments
* Scale Terraform usage across teams and projects

---

## 🌟 Benefits of Using Terraform Modules

* **Reusability:** Write once, use many times
* **Consistency:** Enforce standardized infrastructure patterns
* **Maintainability:** Change logic in one place
* **Scalability:** Manage large and complex infrastructures
* **Collaboration:** Teams can share and reuse modules
* **Abstraction:** Hide implementation details from consumers

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

---

# 🧱 Types of Terraform Modules

Terraform modules are primarily categorized into **Root Modules** and **Child Modules**, with further classification based on where child modules are stored.

---

## 1️⃣ Root Module

The **root module** is the main Terraform configuration that you execute using:

```bash
terraform init
terraform plan
terraform apply
```

### Key Characteristics

* Exists in your **current working directory**
* Every Terraform project has exactly **one root module**
* Calls child modules (if any)
* Controls the overall infrastructure deployment

### Example Structure

```
project/
├── main.tf         # Root module
├── variables.tf
└── outputs.tf
```

---

## 2️⃣ Child Module

A **child module** is a module that is **called by another module** (usually the root module).

### Key Characteristics

* Encapsulates a specific infrastructure component
* Improves reusability and separation of concerns
* Can be called multiple times with different inputs

### Example Usage

```hcl
module "vpc" {
  source = "./modules/vpc"
}
```

---

# 📦 Classification of Child Modules Based on Location

---

## a) Local Modules

Local modules are stored **inside your project directory**.

### Characteristics

* Best for internal reuse
* Easy to modify and debug
* No external dependency

### Example

```hcl
module "vpc" {
  source = "./modules/vpc"
}
```

### Folder Structure Example

```
project/
├── main.tf
└── modules/
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## b) Remote Modules

Remote modules are stored **outside your local project** and are fetched during `terraform init`.

### Common Remote Sources

* Terraform Registry
* GitHub
* GitLab
* Bitbucket
* Private Git repositories

---

### 🌐 Example – Terraform Registry Module

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
}
```

✔ Versioned
✔ Verified
✔ Widely used

---

### 📁 Example – GitHub Module

```hcl
module "vpc" {
  source = "git::https://github.com/bhuvan-raj/my-vpc-module.git"
}
```

You can also reference:

* Branches
* Tags
* Commits

```hcl
source = "git::https://github.com/org/repo.git?ref=v1.0.0"
```

---

## c) Published Modules

Published modules are **well-structured, versioned, and documented modules** intended for reuse by teams or the wider community.

### Characteristics

* Follow Terraform naming conventions
* Versioned using semantic versioning
* Often stored in Terraform Registry or private registries

### Naming Convention

```
terraform-<PROVIDER>-<MODULE_NAME>
```

Example:

```
terraform-aws-vpc
terraform-aws-ec2
```

---

# 🧩 Anatomy of a Terraform Module

A typical module contains:

```
module-name/
├── main.tf       # Resource definitions
├── variables.tf  # Input variables
├── outputs.tf    # Output values
└── README.md     # Documentation (recommended)
```

---

# 🔁 Module Inputs and Outputs

### Input Variables

* Allow passing values into modules
* Make modules configurable

```hcl
variable "cidr_block" {
  type = string
}
```

### Outputs

* Expose values from modules to parent modules

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

---

# 🔄 Calling a Module with Inputs

```hcl
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}
```

---

# ⭐ Best Practices for Terraform Modules

* Keep modules **small and focused**
* Use **variables** instead of hardcoding values
* Always define **outputs** for important resources
* Follow consistent **naming conventions**
* Version your modules
* Document modules using `README.md`
* Avoid putting providers inside reusable modules (unless required)

---

# 🎯 Summary

* A Terraform module is a **reusable unit of infrastructure code**
* Root module = entry point of execution
* Child modules = reusable components
* Modules can be local, remote, or published
* Modules improve **reusability, scalability, and maintainability**
* Core building block for real-world Terraform projects
