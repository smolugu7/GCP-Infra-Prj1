# ❗ Common Errors & Fixes from This Project

This document captures real issues I encountered while building the CI/CD + Policy-as-Code pipeline using Terraform, Cloud Build, and Conftest.

---

🔻 Error 1: Terraform initialized in an empty directory

**Build Error:**

**Cause:**  
Cloud Build was running from the root, but Terraform files were in `infra-project/terraform`.

**Fix:**  
Added `dir: infra-project/terraform` to all Terraform steps in `cloudbuild.yaml`.

---

🔻 Error 2: `terraform` not found in Conftest container

**Build Error:**

**Cause:**  
Tried running `terraform show -json` inside the `openpolicyagent/conftest` image.

**Fix:**  
Split into two steps:
- Run `terraform show -json tfplan > tfplan.json` inside the Terraform image
- Then run `conftest test tfplan.json` in the Conftest image

---

🔻 Error 3: Rego parse error with `if` and `contains`

**Build Error:**

**Cause:**  
Used modern Rego syntax without importing future keywords.

**Fix (✅ Working Policy):**

```rego
package main

import future.keywords.contains
import future.keywords.if

deny contains msg if {
  some i
  resource := input.resource_changes[i]
  resource.type == "google_storage_bucket"
  not resource.change.after.uniform_bucket_level_access
  msg := "GCS bucket must have uniform bucket-level access enabled"
}

deny contains msg if {
  some i
  resource := input.resource_changes[i]
  resource.type == "google_storage_bucket"
  not resource.change.after.public_access_prevention
  msg := "Public access prevention must be explicitly enabled"
}

---

🔻 Error 4: Policy fails even though public_access_prevention = "enforced" is set

Cause:
OPA policy expects public_access_prevention inside change.after, but Terraform plan structure depends on the provider version.

Fix:
Kept the HCL as: