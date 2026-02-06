
# Terraform Import

## ✅ What is `terraform import`?

`terraform import` is a Terraform command used to **bring existing infrastructure resources under Terraform management** **without recreating them**.

In simple terms:

> It tells Terraform: *“This resource already exists—start tracking it in the state file.”*

Terraform **does not create or modify** the resource during import.
It only updates the **state file** so Terraform knows that the resource exists.

---

## 🧠 Why Do We Need Terraform Import?

Many real-world environments already have infrastructure created manually or by other tools. `terraform import` helps when:

* Infrastructure already exists in AWS/Azure/GCP
* Terraform is introduced later
* Resources were created manually from the cloud console
* Migrating from legacy scripts or tools
* Recovering Terraform state
* Adopting Terraform gradually

---

## 🔄 What `terraform import` Does and Does NOT Do

### ✔ What It Does

* Adds an existing resource to `terraform.tfstate`
* Links Terraform configuration to real infrastructure
* Allows Terraform to manage the resource going forward

### ❌ What It Does NOT Do

* Does **not** create resources
* Does **not** generate `.tf` code
* Does **not** modify infrastructure
* Does **not** import entire environments automatically

> ⚠ You must **write the resource block yourself** before importing.

---

## 📌 Basic Syntax

```bash
terraform import <RESOURCE_ADDRESS> <RESOURCE_ID>
```

### Example (AWS EC2)

```bash
terraform import aws_instance.my_ec2 i-0abcd1234efgh5678
```

---

## 🧱 Required Steps Before Import

### Step 1: Write the Resource Block

Terraform needs a matching resource block.

```hcl
resource "aws_instance" "my_ec2" {
  # Arguments can be empty initially
}
```

---

### Step 2: Run Terraform Init

```bash
terraform init
```

---

### Step 3: Import the Resource

```bash
terraform import aws_instance.my_ec2 i-0abcd1234efgh5678
```

---

### Step 4: Verify State

```bash
terraform state list
terraform state show aws_instance.my_ec2
```

---

### Step 5: Align Configuration with Reality

Run:

```bash
terraform plan
```

Then update the `.tf` file to match the actual resource configuration.

---

## 📦 Common Import Examples

### AWS S3 Bucket

```bash
terraform import aws_s3_bucket.demo my-existing-bucket
```

---

### AWS Security Group

```bash
terraform import aws_security_group.web sg-0123456789abcdef0
```

---

### Azure Resource Group

```bash
terraform import azurerm_resource_group.rg /subscriptions/<sub-id>/resourceGroups/my-rg
```

---

### GCP Compute Instance

```bash
terraform import google_compute_instance.vm my-project/us-central1-a/my-vm
```

---

## 🔎 How Terraform Matches Imported Resources

Terraform matches resources using:

* Provider
* Resource type
* Resource name
* Unique resource ID from the cloud provider

Example:

```hcl
aws_instance.my_ec2
```

* `aws_instance` → resource type
* `my_ec2` → Terraform logical name
* `i-xxxxxx` → cloud resource ID

---

## 🧩 Importing Resources Inside Modules

Importing resources inside modules requires **fully qualified addresses**.

### Example

```bash
terraform import module.vpc.aws_vpc.main vpc-0abc1234def5678
```

---

## 🔄 Importing Multiple Resources

Terraform does **not** support bulk import automatically.

Options:

* Import one resource at a time
* Use scripts to loop imports
* Use tools like:

  * Terraformer
  * Cloud-specific exporters

---

## ⚠ Limitations of Terraform Import

* No automatic `.tf` generation
* Manual work required after import
* Complex resources may require multiple imports
* Resource arguments must match exactly
* Some resources do not support import

---

## 🛠 Best Practices

* Always import into a **clean workspace**
* Import **one resource at a time**
* Immediately run `terraform plan` after import
* Fix drift before applying changes
* Commit state and code after successful import
* Avoid importing unmanaged dependencies accidentally

---

## 🧪 Real-World Use Case Scenario

**Scenario:**
An AWS Security Group was created manually.

**Solution:**

1. Write `aws_security_group` resource block
2. Import security group ID
3. Run `terraform plan`
4. Update `.tf` to match rules
5. Apply changes safely

---

## 🎯 Summary

* `terraform import` brings existing infra into Terraform
* Only updates state, not infrastructure
* Requires manual resource definitions
* Essential for adopting Terraform in existing environments
* Critical for state recovery and migration use cases
