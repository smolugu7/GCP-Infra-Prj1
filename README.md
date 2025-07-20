# 🔧 GCP Infra-as-Code with Terraform + Cloud Build + OPA (Project 1)

This project provisions a full GCP infrastructure stack using **Terraform**, automated via **Cloud Build CI/CD**, and hardened with **policy enforcement** using **OPA/Conftest**.

It’s structured to reflect a real-world, production-minded setup with policy-as-code, reproducible infra, and secure defaults — but also includes the early-stage build errors I encountered and resolved, so others can avoid the same pitfalls.

---

## 📦 Infrastructure Components

Provisioned via Terraform in a monolithic setup (`terraform/` folder):

- **GCS Bucket** for Terraform state (with `uniform_bucket_level_access` and `public_access_prevention`)
- **VPC** with subnet and ingress firewall rule
- **GKE Cluster** with separate node pool
- **BigQuery Dataset**

---

## 🔄 CI/CD Flow with Cloud Build

The CI/CD pipeline is defined in `cloudbuild.yaml` and triggered on every push to the main branch via a **Cloud Build Gen2 trigger connected to GitHub**.

### Pipeline Steps:
1. **Format, Init, Validate Terraform**
2. **Generate Terraform plan**
3. **Convert the plan to JSON**
4. **Run Conftest OPA policies against the plan**
5. **Apply infrastructure (only if policies pass)**

---

## 🔐 Policy-as-Code with OPA

OPA policies live under the `policies/` folder and are evaluated using **Conftest**.

### ✅ Enforced Policies:
- GCS buckets **must** have `uniform_bucket_level_access = true`
- GCS buckets **must** explicitly set `public_access_prevention = enforced`

### Example policy (Rego):

```rego
package main

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "google_storage_bucket"
  not resource.change.after.uniform_bucket_level_access
  msg := "GCS bucket must have uniform bucket-level access enabled"
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "google_storage_bucket"
  not resource.change.after.iam_configuration.public_access_prevention
  msg := "Public access prevention must be explicitly enabled"
}