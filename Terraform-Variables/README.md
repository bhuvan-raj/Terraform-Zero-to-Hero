# Terraform Variables – In-Depth Notes

## 1. What is a Terraform Variable?

A **Terraform variable** is used to **parameterize Terraform configurations**, allowing values to be passed dynamically instead of hardcoding them in `.tf` files.

In simple terms:

> Variables make Terraform code **flexible, reusable, and environment-independent**.

Example:

```hcl
instance_type = var.instance_type
```

---

## 2. Benefits of Using Variables

* Avoids hardcoding values
* Improves reusability across environments (dev, test, prod)
* Simplifies configuration changes
* Enhances readability and maintainability
* Supports automation and CI/CD pipelines
* Enables secure handling of sensitive values

---

## 3. Types of Terraform Variables

Terraform supports multiple **data types** to represent different kinds of values.

---

### 3.1 String

Used for text values.

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}
```

Example usage:

```hcl
provider "aws" {
  region = var.region
}
```

---

### 3.2 Number

Used for numeric values.

```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

---

### 3.3 Boolean

Used for true/false conditions.

```hcl
variable "enable_monitoring" {
  type    = bool
  default = true
}
```

Common use case:

* Conditional resource creation

---

### 3.4 List or Tuple

Used to store an ordered collection of values.

#### List (same type values)

```hcl
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
```

#### Tuple (fixed length, mixed types)

```hcl
variable "example_tuple" {
  type = tuple([string, number, bool])
}
```

---

### 3.5 Map

Used to store key–value pairs.

```hcl
variable "tags" {
  type = map(string)

  default = {
    Environment = "dev"
    Owner       = "terraform"
  }
}
```

Usage:

```hcl
tags = var.tags
```

---

## 4. Variable Block

### Syntax

```hcl
variable "<NAME>" {
  type        = <TYPE>
  default     = <VALUE>
  description = "<DESCRIPTION>"
  sensitive   = true | false
}
```

### Example

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

---

### Important Variable Block Arguments

* `type` – Defines expected data type
* `default` – Optional default value
* `description` – Documentation purpose
* `sensitive` – Hides value in CLI output

---

## 5. Ways to Provide Values to Variables

Terraform supports **multiple methods** to assign values to variables. These methods follow a **defined precedence order**.

---

### 5.1 Default Value (Inside Variable Block)

```hcl
variable "region" {
  default = "us-east-1"
}
```

Used when no other value is provided.

---

### 5.2 Command-Line Option (`-var`)

```bash
terraform apply -var="instance_type=t3.micro"
```

Useful for quick overrides.

---

### 5.3 Variable Files (`.tfvars`)

```hcl
region        = "us-east-1"
instance_type = "t3.micro"
```

Apply using:

```bash
terraform apply -var-file="terraform.tfvars"
```

---

### 5.4 Automatically Loaded Variable Files

Terraform automatically loads:

* `terraform.tfvars`
* `terraform.tfvars.json`
* `*.auto.tfvars`
* `*.auto.tfvars.json`

No CLI flags required.

---

### 5.5 Environment Variables

Terraform reads variables prefixed with `TF_VAR_`.

```bash
export TF_VAR_region="us-east-1"
```

Secure and CI/CD friendly.

---

### 5.6 Interactive Input

If no value is provided, Terraform prompts:

```text
var.instance_type
  Enter a value:
```

---

## 6. Variable Precedence Order

From **lowest to highest** priority:

1. Default values
2. `terraform.tfvars`
3. `*.auto.tfvars`
4. Environment variables (`TF_VAR_`)
5. `-var-file`
6. `-var` command-line option

Higher priority overrides lower ones.

---

## 7. What is `variables.tf`?

* A **convention-based file**
* Used to define all variable blocks
* Improves code organization
* Not mandatory, but recommended

Example:

```hcl
variable "region" {}
variable "instance_type" {}
```

---

## 8. What is `terraform.tfvars`?

* Used to assign values to variables
* Automatically loaded by Terraform
* Typically environment-specific

Example:

```hcl
region        = "us-east-1"
instance_type = "t3.micro"
```

---

## 9. Sensitive Variables

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

* Hidden in CLI output
* Still stored securely in state file
* Best combined with secret managers

---

## 10. Best Practices for Terraform Variables

* Always define `type`
* Use meaningful variable names
* Avoid hardcoding sensitive values
* Separate variables and values
* Use `.tfvars` per environment
* Document variables clearly

---

## Summary

* Variables make Terraform flexible and reusable
* Supports multiple data types: string, number, bool, list/tuple, map
* Values can be provided in many ways
* `variables.tf` defines variables
* `terraform.tfvars` assigns values
* Proper variable usage is critical for production-ready Terraform

