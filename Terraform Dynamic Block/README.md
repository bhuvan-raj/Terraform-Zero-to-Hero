
# Dynamic Blocks in Terraform

## What is a Dynamic Block?

A **dynamic block** in Terraform is used to **dynamically generate nested blocks** inside a resource, data source, provider, or module based on input variables or expressions.

Terraform configuration is normally **static** — you must explicitly write every nested block. Dynamic blocks allow you to **loop over a collection** and create nested blocks programmatically.

Dynamic blocks are mainly used when:

* A resource requires **repeated nested blocks**
* The number of nested blocks is **unknown or variable**
* You want to **avoid code duplication**

> Important: Dynamic blocks **do not create resources**. They only create **nested configuration blocks** inside a resource.

---

## Why Dynamic Blocks Are Needed

Without dynamic blocks, Terraform configurations can become:

* Repetitive
* Hard to maintain
* Error-prone when scaling

### Example Problem (Without Dynamic Block)

```hcl
resource "aws_security_group" "example" {
  name = "example-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

If you have 10–20 rules, this becomes messy.

---

## Benefits of Dynamic Blocks

* Removes repetitive code
* Makes configuration **data-driven**
* Improves readability and scalability
* Enables reusable and modular Terraform code
* Works cleanly with `for_each` and complex variables

---

## Basic Syntax of a Dynamic Block

```hcl
dynamic "<block_name>" {
  for_each = <collection>

  content {
    # configuration using each.value
  }
}
```

### Key Components

| Component    | Purpose                              |
| ------------ | ------------------------------------ |
| `block_name` | Name of the nested block to generate |
| `for_each`   | Collection to iterate over           |
| `content`    | Actual block body                    |
| `each.key`   | Key (for maps/sets)                  |
| `each.value` | Value of the current iteration       |

---

## Simple Dynamic Block Example

### Variable Definition

```hcl
variable "ports" {
  type    = list(number)
  default = [22, 80, 443]
}
```

### Using Dynamic Block

```hcl
resource "aws_security_group" "example" {
  name = "dynamic-sg"

  dynamic "ingress" {
    for_each = var.ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

Terraform will generate **three ingress blocks automatically**.

---

## Using Dynamic Block with Map (Multiple Values)

Dynamic blocks become powerful when combined with **maps of objects**.

### Variable with Multiple Attributes

```hcl
variable "ingress_rules" {
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = list(string)
  }))
}
```

### tfvars Example

```hcl
ingress_rules = {
  ssh = {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr      = ["0.0.0.0/0"]
  }
  http = {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr      = ["0.0.0.0/0"]
  }
}
```

### Dynamic Block Usage

```hcl
resource "aws_security_group" "example" {
  name = "complex-dynamic-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }
}
```

---

## Using `for_each` vs `dynamic` Blocks

| Feature                | for_each | dynamic |
| ---------------------- | -------- | ------- |
| Creates resources      | Yes      | No      |
| Creates nested blocks  | No       | Yes     |
| Used at resource level | Yes      | No      |
| Used inside resources  | No       | Yes     |

---

## Conditional Dynamic Blocks

You can conditionally create nested blocks.

```hcl
dynamic "logging" {
  for_each = var.enable_logging ? [1] : []

  content {
    bucket = "my-log-bucket"
  }
}
```

If `enable_logging = false`, the block is **not created at all**.

---

## Dynamic Blocks in Providers

Dynamic blocks can also be used in **provider configuration**.

```hcl
provider "aws" {
  region = "us-east-1"

  dynamic "assume_role" {
    for_each = var.role_arn != "" ? [var.role_arn] : []

    content {
      role_arn = assume_role.value
    }
  }
}
```

---

## Nested Dynamic Blocks

Dynamic blocks can be **nested inside other dynamic blocks**.

```hcl
dynamic "ingress" {
  for_each = var.ingress_rules

  content {
    from_port = ingress.value.from_port
    to_port   = ingress.value.to_port
    protocol  = ingress.value.protocol

    dynamic "cidr_blocks" {
      for_each = ingress.value.cidr

      content {
        cidr_blocks = cidr_blocks.value
      }
    }
  }
}
```

Use this carefully — readability matters.

---

## Common Use Cases

* Security group rules
* Load balancer listeners
* IAM policy statements
* Autoscaling policies
* Kubernetes manifests
* CloudFront behaviors
* Firewall rules

---

## Limitations of Dynamic Blocks

* Cannot generate **top-level resources**
* Can reduce readability if overused
* Debugging can be harder
* Requires strong understanding of data structures

---

## Best Practices

* Use dynamic blocks **only when repetition is unavoidable**
* Prefer maps of objects for clarity
* Keep variable structures simple
* Comment complex dynamic logic
* Avoid deeply nested dynamic blocks unless required

---

## Interview Tip

> **Dynamic blocks are used to generate repeated nested blocks dynamically, not to create resources.**


