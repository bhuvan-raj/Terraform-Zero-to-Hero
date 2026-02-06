
# Multi-Provider Setup in Terraform – In-Depth Notes

## 1. What is a Multi-Provider Setup?

A **multi-provider setup** in Terraform refers to using **more than one provider** in a single Terraform configuration. This can mean:

* Using **multiple cloud providers** (AWS + Azure + GCP)
* Using **multiple regions** of the same provider
* Using **multiple accounts/subscriptions** of the same provider

Terraform supports this using **provider configurations and provider aliases**.

---

## 2. Why Do We Need Multi-Provider Setups?

Multi-provider configurations are commonly used to:

* Deploy infrastructure across **multiple cloud platforms**
* Create **multi-region architectures**
* Manage **separate environments** (dev, staging, prod)
* Handle **shared services** and **isolated accounts**
* Support **disaster recovery and high availability**
* Migrate workloads between providers

---

## 3. Terraform Provider Basics (Quick Recap)

A provider tells Terraform **how to communicate with an external API**.

Basic provider configuration:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

This is the **default provider configuration**.

---

## 4. Multiple Providers of Different Types

### Example: AWS + Azure

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}
```

Now Terraform can:

* Create AWS resources
* Create Azure resources
* Manage them in the same run

---

## 5. Multiple Configurations of the Same Provider (Provider Alias)

When you need **more than one configuration of the same provider**, you must use **aliases**.

### Why Aliases Are Required

Terraform allows only **one default provider** per provider type.
Additional configurations must use `alias`.

---

### Example: Multi-Region AWS Setup

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}
```

* Default provider → `us-east-1`
* Aliased provider → `ap-south-1`

---

## 6. Using Aliased Providers in Resources

Resources must explicitly reference the aliased provider.

```hcl
resource "aws_instance" "us_server" {
  ami           = "ami-0abcd1234"
  instance_type = "t2.micro"
}

resource "aws_instance" "india_server" {
  provider      = aws.mumbai
  ami           = "ami-0abcd5678"
  instance_type = "t2.micro"
}
```

---

## 7. Multi-Account Setup Using Providers

### Example: AWS Prod and Dev Accounts

```hcl
provider "aws" {
  alias   = "dev"
  region  = "us-east-1"
  profile = "dev"
}

provider "aws" {
  alias   = "prod"
  region  = "us-east-1"
  profile = "prod"
}
```

Usage:

```hcl
resource "aws_s3_bucket" "dev_bucket" {
  provider = aws.dev
  bucket   = "dev-bucket-example"
}

resource "aws_s3_bucket" "prod_bucket" {
  provider = aws.prod
  bucket   = "prod-bucket-example"
}
```

---

## 8. Multi-Provider Setup with Modules

### Passing Providers to Modules

By default, modules inherit the **default provider only**.

To use aliased providers inside modules, they must be explicitly passed.

#### Root Module

```hcl
module "network_us" {
  source = "./network"

  providers = {
    aws = aws
  }
}

module "network_india" {
  source = "./network"

  providers = {
    aws = aws.mumbai
  }
}
```

---

#### Inside the Module

```hcl
provider "aws" {
  # Configuration inherited from root
}
```

---

## 9. Data Blocks with Multiple Providers

Data sources can also use aliased providers.

```hcl
data "aws_ami" "us_ami" {
  most_recent = true
}

data "aws_ami" "india_ami" {
  provider    = aws.mumbai
  most_recent = true
}
```

---

## 10. Common Multi-Provider Use Cases

### 1. Multi-Region High Availability

* Load balancers in multiple regions
* Active-active or active-passive setups

### 2. Disaster Recovery

* Primary infrastructure in one region
* Backup infrastructure in another region

### 3. Hybrid Cloud

* AWS for compute
* Azure for identity
* GCP for analytics

### 4. Shared Services Model

* Central networking account
* Separate application accounts

---

## 11. Provider Configuration Best Practices

* Use aliases with **clear names**
* Keep provider configuration minimal
* Avoid hardcoding credentials
* Use environment variables or secret managers
* Document provider usage clearly
* Pass providers explicitly to modules

---

## 12. Common Mistakes in Multi-Provider Setup

* Forgetting to use `provider = aws.alias`
* Not passing providers into modules
* Mixing regions unintentionally
* Hardcoding region-specific values
* Using one state file for unrelated providers

---

## 13. Key Limitations and Considerations

* Each provider has its own API limitations
* Cross-provider dependencies must be handled carefully
* Terraform does not manage data transfer between clouds
* Debugging becomes more complex

---

## Summary

* Multi-provider setup allows Terraform to manage **multiple clouds, regions, or accounts**
* Uses **provider aliases** for multiple configurations of the same provider
* Resources and data sources must explicitly reference aliased providers
* Essential for production-grade, scalable architectures

