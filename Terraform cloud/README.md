
# Terraform Cloud 
<img src="https://github.com/bhuvan-raj/Terraform-Zero-to-Hero/blob/main/cloud.jpg" alt="Banner" />


## 1. What is Terraform Cloud?

**Terraform Cloud** is a managed service provided by HashiCorp that enables teams to **run Terraform centrally**, collaborate securely, manage state remotely, and enforce governance controls. It removes the need to manage local backends, credentials, and execution environments.

Terraform Cloud provides:

* Remote state storage
* Secure state locking
* Remote Terraform runs
* Team collaboration
* Policy enforcement
* Audit logs and run history

---

## 2. Key Components of Terraform Cloud

### a. Organization

An **organization** is the top-level entity in Terraform Cloud.
It represents a company, team, or training group.

Everything in Terraform Cloud exists inside an organization:

* Projects
* Workspaces
* Teams
* Variables
* Policies

---

## 3. Terraform Cloud Projects

### What is a Project?

A **project** is a logical grouping of related Terraform workspaces.
It helps organize infrastructure by:

* Application
* Environment (dev, test, prod)
* Team or department

Projects improve **visibility, access control, and structure**.

### Why Projects Are Important

* Better organization of workspaces
* Centralized permission management
* Easier navigation in large environments
* Separation of concerns between teams

### Example Project Structure

* Project: `Ecommerce-App`

  * Workspace: `dev-network`
  * Workspace: `dev-app`
  * Workspace: `prod-network`
  * Workspace: `prod-app`

---

## 4. Terraform Cloud Workspaces

### What is a Workspace?

A **Terraform Cloud workspace** represents a **single Terraform state and execution environment**.

Each workspace has:

* Its own state file
* Its own variables
* Its own run history
* Its own permissions

In Terraform Cloud:

> **One workspace = one state file**

---

### Types of Workspaces

#### 1. CLI-Driven Workspace

* Terraform is executed locally
* State is stored in Terraform Cloud
* Common for learning and small teams

#### 2. VCS-Driven Workspace

* Connected to GitHub/GitLab/Bitbucket
* Runs triggered automatically on git push
* Used in real-world CI/CD pipelines

---

### Workspace vs Local Terraform

| Feature        | Local Terraform | Terraform Cloud Workspace |
| -------------- | --------------- | ------------------------- |
| State storage  | Local file      | Remote                    |
| Collaboration  | Manual          | Built-in                  |
| Locking        | Optional        | Automatic                 |
| Run history    | No              | Yes                       |
| Access control | No              | Yes                       |

---

## 5. Terraform Cloud Variables

Each workspace supports two variable types:

### a. Terraform Variables

* Used by Terraform code
* Example: `region`, `instance_type`

### b. Environment Variables

* Used for credentials
* Example: `AWS_ACCESS_KEY_ID`

Variables can be:

* Plain text
* Sensitive (hidden in UI and logs)

---


## Setting Up Terraform Cloud (CLI-Driven Workflow – GUI Steps)

### Step 1: Create a Terraform Cloud Account

1. Go to **[https://app.terraform.io](https://app.terraform.io)**
2. Click **Sign up**
3. Register using email or GitHub
4. Verify email and log in

---

### Step 2: Create an Organization

1. From the Terraform Cloud dashboard, click **New Organization**
2. Enter:

   * Organization name
   * Contact email
3. Click **Create Organization**

---

### Step 3: Create a Project

1. Inside the organization, click **Projects**
2. Click **New Project**
3. Provide:

   * Project name (e.g., `terraform-training`)
   * Optional description
4. Click **Create Project**

---

### Step 4: Create a Workspace (CLI-Driven)

1. Inside the project, click **New Workspace**
2. Select **CLI-Driven Workflow**
3. Enter:

   * Workspace name (e.g., `aws-dev`)
4. Select the **Project** you created
5. Click **Create Workspace**

✔ No repository connection
✔ Terraform runs will be executed from local CLI
✔ State will be stored remotely in Terraform Cloud

---

### Step 5: Configure Workspace Variables (GUI)

1. Open the workspace
2. Go to **Variables**
3. Add **Terraform Variables** (used by `.tf` files)

   * Example:

     * Key: `region`
     * Value: `us-east-1`
4. Add **Environment Variables** (for credentials)

   * `AWS_ACCESS_KEY_ID`
   * `AWS_SECRET_ACCESS_KEY`
5. Mark sensitive values as **Sensitive**
6. Click **Save**

---

### Step 6: Configure Execution Mode

1. Go to **Workspace → Settings → General**
2. Under **Execution Mode**, select:

   * **Remote**
3. Save settings

This ensures:

* Terraform runs execute in Terraform Cloud
* Only commands are triggered from local CLI

---

### Step 7: Configure Terraform CLI to Use Terraform Cloud

1. Open the workspace
2. Go to **Settings → General**
3. Copy the **Organization name** and **Workspace name**
4. Terraform Cloud automatically provides the backend configuration details

In your local project directory, Terraform will prompt to authenticate when you run `terraform init`.

---

### Step 8: Authenticate Terraform CLI

From your local terminal:

```bash
terraform login
```

1. Browser opens
2. Log in to Terraform Cloud
3. Generate and approve the API token
4. Token is stored locally

---

### Step 9: Initialize Terraform

Run inside your Terraform project directory:

```bash
terraform init
```

Terraform will:

* Detect Terraform Cloud
* Configure remote backend automatically
* Associate the local code with the workspace

---

### Step 10: Run Terraform via CLI

```bash
terraform plan
terraform apply
```

What happens:

* Commands are triggered locally
* Execution happens in Terraform Cloud
* Output and logs appear in the UI
* State is stored remotely and locked automatically

---

## CLI-Driven vs VCS-Driven (Quick Comparison)

| Feature           | CLI-Driven | VCS-Driven  |
| ----------------- | ---------- | ----------- |
| Git integration   | ❌ No       | ✅ Yes       |
| Trigger runs      | Manual CLI | Git push    |
| Learning-friendly | ✅ Yes      | ⚠️ Moderate |
| CI/CD ready       | ⚠️ Limited | ✅ Yes       |
| State storage     | Remote     | Remote      |

---

## When to Use CLI-Driven Workflow

* Training and learning environments
* Individual developers
* Testing Terraform Cloud
* Manual infrastructure control
* When VCS integration is not required

---

## Summary

* **CLI-driven workflow** uses local Terraform commands
* **State, locking, and execution** happen in Terraform Cloud
* Setup is fully done via **GUI + local CLI**
* Ideal for labs, demos, and classroom teaching

---


## 7. Terraform Cloud Run Lifecycle (GUI View)

1. **Plan Phase**

   * Shows proposed changes
2. **Policy Check (Optional)**
3. **Apply Phase**

   * Resources created/updated
4. **State Updated**

   * Stored securely in Terraform Cloud

All runs are logged and auditable.

---

## 8. Benefits of Terraform Cloud

* Centralized state management
* Built-in state locking
* Secure secret storage
* Team collaboration
* Audit and compliance readiness
* No backend configuration required
* Ideal for training, teams, and production

---

## 9. When to Use Terraform Cloud

* Team-based Terraform usage
* CI/CD automation
* Training environments
* Production-grade infrastructure
* Governance and compliance requirements

---

## Summary

* **Terraform Cloud** centralizes Terraform execution and state
* **Projects** group related workspaces
* **Workspaces** represent individual Terraform states
* GUI-based setup is straightforward and production-ready
* Eliminates backend and locking complexity
