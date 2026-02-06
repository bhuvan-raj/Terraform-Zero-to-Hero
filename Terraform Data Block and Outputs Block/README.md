
# Terraform Data Block and Output Block

## 1. Terraform Data Block

### What is a Data Block?

A **data block** in Terraform is used to **fetch or read information about existing infrastructure or external data** without creating or modifying any resources.

In simple words:

> **Resource block = creates or manages something**
> **Data block = reads something that already exists**

Terraform uses data blocks to query:

* Existing cloud resources
* Provider-specific metadata
* Outputs from other Terraform configurations
* External data sources

---

### Why Do We Need Data Blocks?

Data blocks are required when:

* You want to **reuse existing infrastructure**
* You should **not recreate resources**
* You need **dynamic values** (IDs, ARNs, IPs, names)
* You want Terraform configurations to be **portable and environment-agnostic**

Example scenarios:

* Fetch the **latest AMI ID** instead of hardcoding it
* Use an **existing VPC or subnet**
* Read an **existing security group**
* Query availability zones dynamically

---

### Basic Syntax of a Data Block

```hcl
data "<PROVIDER>_<DATA_SOURCE>" "<NAME>" {
  # filters or arguments
}
```

Example:

```hcl
data "aws_vpc" "default" {
  default = true
}
```

Here:

* `aws_vpc` → data source
* `default` → local reference name
* Terraform only **reads**, it does not create the VPC

---

### Accessing Data Block Values

You access data block attributes using:

```hcl
data.<TYPE>.<NAME>.<ATTRIBUTE>
```

Example:

```hcl
data.aws_vpc.default.id
```

---

### Common AWS Data Block Examples

#### 1. Fetch Latest Amazon Linux AMI

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

Usage:

```hcl
ami = data.aws_ami.amazon_linux.id
```

---

#### 2. Fetch Existing Subnet

```hcl
data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet"]
  }
}
```

---

#### 3. Fetch Availability Zones

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

## Filtering in Terraform Data Blocks 

Filtering in Terraform **data blocks** is used to narrow down and select the exact existing resource that Terraform should read. Proper filtering ensures accuracy, avoids ambiguity, and prevents Terraform from returning multiple or incorrect results.

### Common Ways to Filter

* **Filter Block:**
  Uses attribute-based filters supported by the provider.

  ```hcl
  filter {
    name   = "tag:Name"
    values = ["public-subnet"]
  }
  ```

* **Direct Arguments:**
  Some data sources allow filtering using built-in arguments.

  ```hcl
  data "aws_vpc" "default" {
    default = true
  }
  ```

* **Tag-Based Filtering:**
  Common in production environments for stable resource selection.

  ```hcl
  name = "tag:Environment"
  ```

* **ID-Based Filtering:**
  Used when the exact resource ID is known.

  ```hcl
  id = "sg-0abcd1234"
  ```

* **`most_recent` Flag:**
  Ensures the latest matching resource is selected (commonly used with AMIs).

### Key Points

* All filters are evaluated together (logical AND)
* Poor filtering can lead to multiple-match errors
* Tag-based filtering is considered a best practice
* Filtering behavior depends on the provider and data source

---

### Key Characteristics of Data Blocks

* Read-only (no create/update/delete)
* Evaluated during `terraform plan`
* Do not appear as managed resources in state
* Can fail if resource does not exist
* Highly useful for **production environments**

---

### Best Practices for Data Blocks

* Prefer data blocks over hardcoded values
* Use filters carefully to avoid ambiguity
* Avoid relying on unstable attributes (like names that may change)
* Document what existing resource is being fetched

---

## 2. Terraform Output Block

### What is an Output Block?

An **output block** is used to **display or expose values** from Terraform after execution.

In simple words:

> Output blocks show you **important information** about your infrastructure.

Terraform outputs are commonly used for:

* Displaying values to users
* Passing data between Terraform modules
* Integrating Terraform with CI/CD pipelines
* Debugging and verification

---

### Basic Syntax of Output Block

```hcl
output "<NAME>" {
  value = <EXPRESSION>
}
```

Example:

```hcl
output "instance_id" {
  value = aws_instance.web.id
}
```

---

### When Are Outputs Evaluated?

* Outputs are shown after `terraform apply`
* Can be viewed anytime using:

  ```bash
  terraform output
  ```

---

### Accessing Output Values

#### List all outputs

```bash
terraform output
```

#### Get a specific output

```bash
terraform output instance_id
```

#### Get output in JSON

```bash
terraform output -json
```

---

### Output Block with Description

```hcl
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}
```

---

### Sensitive Outputs

To prevent secrets from being printed:

```hcl
output "db_password" {
  value     = var.db_password
  sensitive = true
}
```

* Value will not be displayed in CLI
* Still stored securely in the state file

---

### Outputs for Module Communication

#### Child Module Output

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

#### Parent Module Usage

```hcl
module "network" {
  source = "./vpc"
}

output "network_vpc_id" {
  value = module.network.vpc_id
}
```

---

### Output vs Data Block (Important Comparison)

| Feature              | Data Block         | Output Block          |
| -------------------- | ------------------ | --------------------- |
| Purpose              | Read existing data | Display/export values |
| Creates resources    | ❌ No               | ❌ No                  |
| Used inside config   | ✅ Yes              | ❌ No                  |
| Used after apply     | ❌ No               | ✅ Yes                 |
| Module communication | ❌ No               | ✅ Yes                 |

---

### Best Practices for Output Blocks

* Output only meaningful values
* Avoid exposing secrets unless marked sensitive
* Use clear and consistent names
* Document outputs in shared modules
* Keep outputs minimal in production

---

## Real-World Use Case Example

```hcl
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.latest.id
  instance_type = "t2.micro"
}

output "app_public_ip" {
  value = aws_instance.app.public_ip
}
```

---

## Summary

* **Data blocks** read existing infrastructure or metadata
* **Output blocks** expose important values after provisioning
* Together, they enable **dynamic, reusable, and production-ready Terraform code**
* They are essential for modular design and automation pipelines

