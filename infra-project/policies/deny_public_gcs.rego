package main

deny[msg] {
  some i
  resource := input.resource_changes[i]
  resource.type == "google_storage_bucket"
  not resource.change.after.uniform_bucket_level_access
  msg := "GCS bucket must have uniform bucket-level access enabled"
}

deny[msg] {
  some i
  resource := input.resource_changes[i]
  resource.type == "google_storage_bucket"
  not resource.change.after.iam_configuration.public_access_prevention
  msg := "Public access prevention must be explicitly enabled"
}