package terraform.gcp.gcs

deny[msg] if {
  some r in input.resource_changes
  r.type == "google_storage_bucket"
  r.change.after.uniform_bucket_level_access == false
  msg := "GCS buckets must have uniform bucket-level access enabled"
}

deny[msg] if {
  some r in input.resource_changes
  r.type == "google_storage_bucket"
  not r.change.after.iam_configuration.public_access_prevention
  msg := "Public access prevention must be explicitly enabled on GCS buckets"
}