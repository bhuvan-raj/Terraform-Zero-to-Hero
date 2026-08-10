<div align="center">

# 🌍 Terraformer

### Generate Terraform configuration from your existing cloud infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![GCP](https://img.shields.io/badge/GCP-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)](https://cloud.google.com/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](#)

</div>

Terraformer is an open-source tool that helps generate Terraform configuration from existing infrastructure. It can be used to **import existing infrastructure into Terraform** by generating Terraform configuration files and state information from resources that already exist in a cloud environment.

---

## 📚 Table of Contents

| Topic |
|---|
| [What is Terraformer?](#-what-is-terraformer) |
| [Why Terraformer?](#-why-terraformer) |
| [How Terraformer Works](#-how-terraformer-works) |
| [Terraformer Workflow](#-terraformer-workflow) |
| [Installation](#-installation) |
| [Terraformer Commands](#-terraformer-commands) |
| [Import Existing Infrastructure](#-import-existing-infrastructure) |
| [Generated Terraform Files](#-generated-terraform-files) |
| [Using Generated Configuration](#-using-generated-configuration) |
| [Practical Example](#-practical-example) |
| [Important Considerations](#-important-considerations) |
| [Limitations](#-limitations) |
| [Key Takeaway](#-key-takeaway) |

---

## 🔹 What is Terraformer?

Terraformer is a tool that generates Terraform configuration from existing infrastructure.

Instead of manually writing Terraform configuration for infrastructure that already exists, Terraformer can inspect the existing resources and generate Terraform configuration for them.

```text
Existing Infrastructure
        ↓
    Terraformer
        ↓
Terraform Configuration
        ↓
    Terraform
        ↓
Manage Infrastructure as Code
```

---

## 🔹 Why Terraformer?

Terraform normally follows:

```text
Terraform Configuration
        ↓
      Terraform
        ↓
Cloud Infrastructure
```

But when infrastructure already exists, manually recreating the Terraform configuration can be time-consuming. Terraformer helps with:

```text
Existing Cloud Infrastructure
        ↓
    Terraformer
        ↓
Generated Terraform Configuration
```

It is useful when:

- Existing infrastructure was created manually
- Migrating existing infrastructure to Terraform
- Converting existing cloud resources into Infrastructure as Code
- Quickly generating an initial Terraform configuration

---

## 🔹 How Terraformer Works

Terraformer connects to the cloud provider and discovers existing resources. It then generates Terraform configuration and state information for the discovered resources.

```text
Cloud Provider
      ↓
Existing Resources
      ↓
  Terraformer
      ↓
Generated .tf files
      ↓
Terraform State
```

---

## 🔹 Terraformer Workflow

```text
Existing Infrastructure
        ↓
   ┌──────────────┐
   │ Terraformer  │
   └──────┬───────┘
          ↓
Generated Terraform
    Configuration
          ↓
  Review / Modify
          ↓
   terraform init
          ↓
   terraform plan
          ↓
Terraform Management
```

> Terraformer should be treated as a **starting point for importing infrastructure into Terraform**, not as a replacement for properly designing and maintaining Terraform code.

---

## 🔹 Installation

Terraformer can be installed using the appropriate binary for your operating system.

Verify the installation:

```bash
terraformer --version
```

---

## 🔹 Terraformer Commands

Check the available commands:

```bash
terraformer --help
```

List available providers:

```bash
terraformer import --help
```

Provider-specific import commands can then be used to discover and generate configuration for existing resources.

---

## 🔹 Import Existing Infrastructure

Terraformer supports importing resources from supported cloud providers. For example, to import AWS infrastructure:

```bash
terraformer import aws
```

You can specify the resources you want to import:

```bash
terraformer import aws --resources=vpc,subnet
```

You can also specify regions:

```bash
terraformer import aws --resources=vpc,subnet --regions=us-east-1
```

> The exact supported resources and command options depend on the Terraformer provider and version being used.

---

## 🔹 Generated Terraform Files

Terraformer generates Terraform configuration based on the resources it discovers. A generated structure may look similar to:

```text
generated/
└── aws/
    ├── vpc/
    │   ├── provider.tf
    │   ├── vpc.tf
    │   └── outputs.tf
    │
    └── subnet/
        ├── provider.tf
        ├── subnet.tf
        └── outputs.tf
```

> The generated files should be reviewed before being used in a production Terraform project.

---

## 🔹 Using Generated Configuration

After Terraformer generates the configuration, move or copy the required files into your Terraform project.

Initialize Terraform:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```

Review the Terraform plan:

```bash
terraform plan
```

> The generated configuration should be carefully reviewed before applying changes.

---

## 🔹 Practical Example

Consider an AWS environment containing:

```text
AWS
│
├── VPC
├── Subnets
├── Internet Gateway
└── Route Tables
```

Instead of manually writing Terraform configuration for each resource:

```text
Existing AWS Infrastructure
          ↓
       Terraformer
          ↓
Generated Terraform Files
          ↓
      Review Code
          ↓
   terraform init
          ↓
  terraform validate
          ↓
   terraform plan
```

The generated configuration can then be cleaned up, reorganized, and incorporated into a proper Terraform project.

---

## 🔹 Important Considerations

Terraformer generates configuration based on the infrastructure it discovers.

The generated code may not follow the structure, naming conventions, modules, variables, or standards used by your Terraform project. Therefore:

```text
Terraformer
    ↓
Generated Configuration
    ↓
   Review
    ↓
Clean / Refactor
    ↓
Terraform Project
```

> Always review the generated configuration before using it in production.

---

## 🔹 Limitations

Terraformer is primarily useful for **bootstrapping Terraform configuration from existing infrastructure**. Some considerations include:

- Generated configuration may require cleanup
- Generated code may not follow your project's architecture
- Not every resource or provider feature may be supported
- Existing infrastructure may require manual adjustments
- Generated configuration should be validated before use

---

## 🎯 Key Takeaway

Terraformer helps bridge the gap between **existing infrastructure and Infrastructure as Code**.

```text
Existing Infrastructure
          ↓
      Terraformer
          ↓
Generated Terraform
          ↓
    Review / Refactor
          ↓
Terraform-managed Infrastructure
```

It is especially useful when migrating manually created infrastructure into Terraform.

<div align="center">

---

**⭐ If this repository helped you, consider giving it a star!**

[⬆ Back to top](#-terraformer)

</div>
