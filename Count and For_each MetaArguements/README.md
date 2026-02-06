
# Terraform `count` and `for_each` 

Terraform provides **meta-arguments** to create **multiple instances of a resource or module** dynamically.
The two most commonly used ones are:

* `count`
* `for_each`

They solve the same problem (multiple resources) but are used **very differently**.

---

## 🔢 `count` in Terraform

### ✅ What is `count`?

`count` is a meta-argument that creates **multiple identical copies** of a resource or module.

> Best used when resources are **similar and indexed numerically**.

---

### Basic Syntax

```hcl
resource "aws_instance" "web" {
  count = 3

  ami           = "ami-0abcdef"
  instance_type = "t2.micro"
}
```

Terraform creates:

```
aws_instance.web[0]
aws_instance.web[1]
aws_instance.web[2]
```

---

## 📌 `count.index`

`count.index` is a **built-in variable** that gives the **current index** (starting from 0).

### Example: Unique Names Using `count.index`

```hcl
resource "aws_instance" "web" {
  count = 3

  ami           = "ami-0abcdef"
  instance_type = "t2.micro"

  tags = {
    Name = "web-${count.index}"
  }
}
```

Result:

```
web-0
web-1
web-2
```

---

### Using `count` with a List

```hcl
variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

resource "aws_subnet" "public" {
  count             = length(var.azs)
  availability_zone = var.azs[count.index]
}
```

---

## ❌ Limitations of `count`

* Uses numeric indexes → fragile
* Removing an element can **shift indexes**
* Causes unnecessary resource recreation
* Harder to read in complex setups

---

# 🔁 `for_each` in Terraform

### ✅ What is `for_each`?

`for_each` creates resources based on **keys in a map or set**.

> Best used when resources are **distinct and uniquely identifiable**.

---

### Basic Syntax (Map)

```hcl
resource "aws_instance" "web" {
  for_each = {
    web1 = "t2.micro"
    web2 = "t3.micro"
  }

  ami           = "ami-0abcdef"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
```

Terraform creates:

```
aws_instance.web["web1"]
aws_instance.web["web2"]
```

---

## 🔑 `each.key` and `each.value`

| Expression   | Meaning                                  |
| ------------ | ---------------------------------------- |
| `each.key`   | Unique identifier (map key or set value) |
| `each.value` | Value associated with the key            |

---

## 📦 Using `for_each` with a Set

```hcl
resource "aws_s3_bucket" "buckets" {
  for_each = toset(["logs", "images", "backup"])

  bucket = "bubu-${each.key}"
}
```

---

# 🧩 Using `for_each` with Multiple Key-Value Pairs (Advanced)

### Map with Multiple Attributes (Most Important Use Case)

```hcl
variable "instances" {
  type = map(object({
    instance_type = string
    az            = string
    environment   = string
  }))
}
```

### Variable Value

```hcl
instances = {
  web1 = {
    instance_type = "t2.micro"
    az            = "ap-south-1a"
    environment   = "dev"
  }
  web2 = {
    instance_type = "t3.micro"
    az            = "ap-south-1b"
    environment   = "prod"
  }
}
```

---

### Resource Using Multiple Key Values

```hcl
resource "aws_instance" "web" {
  for_each = var.instances

  ami               = "ami-0abcdef"
  instance_type     = each.value.instance_type
  availability_zone = each.value.az

  tags = {
    Name        = each.key
    Environment = each.value.environment
  }
}
```

✔ Multiple attributes
✔ Clear mapping
✔ No index shifting

---

## 📦 `for_each` with Modules

```hcl
module "vpc" {
  for_each = var.vpcs
  source   = "./modules/vpc"

  cidr_block = each.value.cidr
}
```

---

## 🔍 `count` vs `for_each`

| Feature             | `count`             | `for_each`         |
| ------------------- | ------------------- | ------------------ |
| Identifier          | Numeric index       | Meaningful key     |
| Best for            | Identical resources | Distinct resources |
| Readability         | Medium              | High               |
| Safe deletion       | ❌ Risky             | ✅ Safe             |
| Supports map/object | ❌ No                | ✅ Yes              |
| Production use      | Limited             | Preferred          |

---

## 🚫 Rules and Restrictions

* You **cannot use `count` and `for_each` together** on the same resource
* Changing from `count` to `for_each` may cause recreation
* Keys in `for_each` **must be unique**

---

## 🛠 Best Practices

* Use `count` for:

  * Simple identical resources
  * Temporary labs
* Use `for_each` for:

  * Production infrastructure
  * Multi-attribute configurations
  * Modules and reusable patterns
* Prefer `for_each` in real-world Terraform

---

## 🎯 Summary

* `count` creates resources using numeric indexes
* `count.index` helps access the current iteration
* `for_each` uses meaningful keys
* `each.key` and `each.value` give clarity and safety
* `for_each` supports complex objects with multiple values
* `for_each` is the **recommended approach for production**

