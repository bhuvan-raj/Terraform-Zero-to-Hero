
# Provisioners and Provisioning in Terraform

### What is Provisioning in Terraform?

**Provisioning** refers to the process of **executing scripts or commands on a resource after it has been created or before it is destroyed**. While Terraform is primarily designed for **infrastructure provisioning** (servers, networks, load balancers, etc.), provisioners allow limited **configuration-level actions** such as installing packages, copying files, or running initialization scripts.

Terraform’s philosophy is **infrastructure first**, not configuration management. Because of this, provisioners exist as a **last-resort mechanism** and should be used carefully.

---

## What are Provisioners?

**Provisioners** are special blocks inside a Terraform resource that allow you to:

* Run shell commands
* Copy files
* Execute scripts remotely or locally

They are executed:

* **After resource creation** (default)
* **Before resource destruction** (with `when = destroy`)

---

## Types of Provisioners in Terraform

### 1. `local-exec` Provisioner

Runs a command **on the machine where Terraform is executed**, not on the resource.

#### Common Use Cases

* Triggering shell scripts
* Calling APIs
* Running Ansible playbooks
* Sending notifications (Slack, email)
* Updating DNS or CMDB systems

#### Example

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0abc123"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo Instance created with IP ${self.public_ip}"
  }
}
```

📌 **Key Point:**
`local-exec` has no direct control over the remote resource — it only reacts to Terraform events.

---

### 2. `remote-exec` Provisioner

Runs commands **inside the created resource**, typically over SSH or WinRM.

#### Common Use Cases

* Installing packages
* Starting services
* Initial server configuration

#### Example

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0abc123"
  instance_type = "t2.micro"
  key_name      = "my-key"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("my-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}
```

📌 **Important:**
If the connection fails, **Terraform marks the resource as tainted**.

---

### 3. `file` Provisioner

Copies files or directories **from the local system to the remote resource**.

#### Common Use Cases

* Uploading application files
* Copying configuration files
* Transferring scripts before execution

#### Example

```hcl
provisioner "file" {
  source      = "app.conf"
  destination = "/tmp/app.conf"
}
```

This is usually followed by a `remote-exec` provisioner to use the file.

---

## Provisioner Execution Lifecycle

| Phase   | Behavior                         |
| ------- | -------------------------------- |
| Create  | Runs after resource creation     |
| Destroy | Runs before resource destruction |
| Failure | Resource is marked **tainted**   |
| Retry   | Terraform retries on next apply  |

---

## Destroy-Time Provisioners

Provisioners can run **during resource deletion** using:

```hcl
provisioner "local-exec" {
  when    = destroy
  command = "echo Resource is being destroyed"
}
```

📌 **Limitations:**

* Cannot reference `self` attributes except name/type
* No access to values that no longer exist

---

## Connection Block

Provisioners that work on remote resources require a **connection block**.

### SSH Example

```hcl
connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file("id_rsa")
  host        = self.public_ip
}
```

### WinRM Example (Windows)

```hcl
connection {
  type     = "winrm"
  user     = "Administrator"
  password = var.admin_password
  host     = self.public_ip
}
```

---

## Provisioner Failure Behavior

If a provisioner fails:

* Terraform **does NOT roll back**
* Resource is marked **tainted**
* Next `terraform apply` will recreate the resource

You can control failure behavior:

```hcl
provisioner "remote-exec" {
  on_failure = continue
}
```

⚠️ This is risky and generally discouraged.

---

## When Should You Use Provisioners?

### Acceptable Use Cases

* One-time bootstrap actions
* Temporary proof-of-concept setups
* Legacy systems with no automation
* Calling external systems

### NOT Recommended For

* Application configuration
* Long-running configuration tasks
* Idempotent configuration
* Day-2 operations

---

## Preferred Alternatives to Provisioners

| Task                     | Recommended Tool      |
| ------------------------ | --------------------- |
| Software installation    | Cloud-init            |
| Configuration management | Ansible, Chef, Puppet |
| App deployment           | CI/CD pipelines       |
| Secrets handling         | Vault                 |
| AMI creation             | Packer                |

📌 **Best Practice:**
Use Terraform to **create infrastructure**, and use other tools to **configure it**.

---

## Null Resource with Provisioners

A `null_resource` can be used when you don’t want to attach provisioners directly to infrastructure.

```hcl
resource "null_resource" "setup" {
  triggers = {
    instance_id = aws_instance.web.id
  }

  provisioner "local-exec" {
    command = "echo Running setup"
  }
}
```

⚠️ `null_resource` is powerful but easy to misuse.

---

## Provisioners and Idempotency

Provisioners:

* Are **not idempotent**
* Depend on external state
* Can cause unpredictable results

This is one of the main reasons Terraform discourages heavy use of provisioners.

---

## Best Practices Summary

* ✅ Use provisioners **only when unavoidable**
* ❌ Do not replace configuration management tools
* ✅ Prefer cloud-init for bootstrapping
* ❌ Avoid long-running scripts
* ✅ Keep scripts small and simple
* ❌ Do not store secrets in provisioners

---

## Exam / Interview Pointers

* Provisioners are **last-resort**
* Failure causes **taint**
* `local-exec` runs locally
* `remote-exec` runs on resource
* Terraform is **not a configuration management tool**

---
