package terraform.gcp.gcs

deny[msg] {
  input.resource_changes[_].type == "google_storage_bucket"
  input.resource_changes[_].change.after.uniform_bucket_level_access == false
  msg = "GCS buckets must have uniform bucket-level access enabled"
}

deny[msg] {
  some i
  input.resource_changes[i].type == "google_storage_bucket"
  input.resource_changes[i].change.after.iam_configuration.public_access_prevention == "unspecified"
  msg = "Public access prevention must be enforced on GCS buckets"
}