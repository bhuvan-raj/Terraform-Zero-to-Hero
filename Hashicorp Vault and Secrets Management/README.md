

# Secret Management in Terraform

## What is Secret Management?

**Secret management** is the practice of securely storing, accessing, and rotating sensitive information such as:

* Cloud access keys (AWS access key & secret key)
* Database passwords
* API tokens
* Certificates

In Terraform, poor secret management usually means:

* Hardcoding secrets in `.tf` files ❌
* Storing secrets in `terraform.tfvars` ❌
* Committing secrets to Git ❌

Proper secret management ensures:

* Secrets are **never written in code**
* Secrets are **fetched dynamically at runtime**
* Secrets can be **rotated without changing Terraform code**

---

## Ways to Manage Secrets in Terraform

### 1. Environment Variables

Example:

```bash
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=yyy
```

**Pros**

* Simple
* No secrets in code

**Cons**

* Not centralized
* Hard to manage at scale
* No versioning or audit trail

---

### 2. Terraform Variables (`terraform.tfvars`)

Example:

```hcl
access_key = "AKIA..."
secret_key = "xxxx"
```

**Pros**

* Easy to understand

**Cons**

* Secrets exist in plain text
* Can leak via Git, logs, or state files

⚠️ **Not recommended for real environments**

---

### 3. Encrypted Files (SOPS, KMS, etc.)

* Secrets are encrypted before being committed
* Decrypted during Terraform execution

**Pros**

* More secure than plain text

**Cons**

* Extra tooling
* Still file-based

---

### 4. Secret Managers (Best Practice)

Examples:

* HashiCorp Vault ✅
* AWS Secrets Manager
* Azure Key Vault
* Google Secret Manager

**Pros**

* Centralized secret storage
* Access control
* Auditing and rotation
* No secrets in Terraform code

This is the **recommended and professional approach**.

---

# HashiCorp Vault
<img src="https://github.com/bhuvan-raj/Terraform-Zero-to-Hero/blob/main/vault.png" alt="Banner" />

## What is HashiCorp Vault?

HashiCorp Vault is a **centralized secrets management system** that:

* Securely stores secrets
* Provides secrets dynamically via API/CLI
* Supports encryption at rest
* Integrates natively with Terraform

Vault is commonly used to store:

* Cloud credentials
* Database credentials
* Tokens
* Certificates

---

## Why Use Vault with Terraform?

Using Vault with Terraform allows you to:

* Avoid hardcoding credentials
* Pull secrets **at runtime**
* Keep Terraform code **clean and portable**
* Rotate secrets without modifying Terraform files

---

## Vault + Terraform Integration (Lab Explanation)

This lab uses:

* Vault **Dev Mode**
* KV v2 secrets engine
* Terraform **data sources**
* Environment-based authentication

No policies. No variables. No complexity.

---

## Step 1: Start Vault (Lab Setup)

```bash
vault server -dev
```

What this does:

* Starts Vault in memory
* Automatically unseals Vault
* Generates a **root token**
* Suitable only for labs and testing

---

### Export Vault Environment Variables

```bash
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="root"
```

Why this matters:

* Vault CLI uses these automatically
* Terraform Vault provider also picks these up
* No token or address needed in Terraform files

---

## Step 2: Enable KV v2 and Store AWS Credentials

### Enable KV v2

```bash
vault secrets enable -path=aws kv-v2
```

Explanation:

* Enables a **Key-Value version 2** secrets engine
* Supports versioning and rollback
* Mounted at `aws/`

---

### Store AWS Credentials

```bash
vault kv put aws/terraform \
  access_key="AKIAxxxxxxxxxxxx" \
  secret_key="xxxxxxxxxxxxxxxxxxxxxxxx"
```

Result:

* Secrets stored securely inside Vault
* Path: `aws/terraform`
* Keys: `access_key`, `secret_key`

Nothing is stored in Terraform.

---

## Step 3: Terraform Configuration (NO Variables)

### `main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}
```

This block:

* Declares required providers
* Ensures consistent versions
* Downloads Vault and AWS providers during `terraform init`

---

### Vault Provider Configuration

```hcl
provider "vault" {
  address = "http://127.0.0.1:8200"
}
```

Important detail:

* No token specified
* Vault provider automatically reads:

  * `VAULT_ADDR`
  * `VAULT_TOKEN`
* This keeps credentials **out of code**

---

## Step 4: Read AWS Credentials from Vault

```hcl
data "vault_kv_secret_v2" "aws_creds" {
  mount = "aws"
  name  = "terraform"
}
```

What happens here:

* Terraform calls Vault at runtime
* Fetches the latest version of the secret
* Stores it **in memory only**

This is a **read-only operation**, not resource creation.

---

## Step 5: AWS Provider Using Vault Secrets

```hcl
provider "aws" {
  region     = "ap-south-1"
  access_key = data.vault_kv_secret_v2.aws_creds.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]
}
```

Key points:

* AWS credentials are **not hardcoded**
* Pulled dynamically from Vault
* Available only during execution
* Terraform state does **not expose raw credentials**

---

## Step 6: Test Resource

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "bubu-vault-no-vars-demo"
}
```

This confirms:

* AWS provider authentication works
* Vault → Terraform → AWS integration is successful

---

## Step 7: Run Terraform

```bash
terraform init
terraform apply
```

Execution flow:

1. Terraform initializes providers
2. Vault provider authenticates via env vars
3. Terraform reads secrets from Vault
4. AWS provider uses fetched credentials
5. Resource is created successfully

---

## Why This Approach Is Powerful

✔ No variables
✔ No credentials in `.tf` files
✔ No secrets in Git
✔ Secrets fetched at runtime
✔ Clean, production-style workflow

---

## Important Notes

* Vault **dev mode** is only for labs
* In real environments:

  * Vault runs in HA mode
  * Auth uses IAM, Kubernetes, AppRole, etc.
* The Terraform logic remains **exactly the same**


