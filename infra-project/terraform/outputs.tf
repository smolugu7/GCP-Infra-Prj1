output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.gke.name
}

output "cluster_endpoint" {
  value       = google_container_cluster.gke.endpoint
  description = "Endpoint to access GKE cluster"
}

output "node_pool_name" {
  value       = google_container_node_pool.primary_nodes.name
  description = "Name of the node pool"
}

output "node_pool_instance_group_urls" {
  value       = google_container_node_pool.primary_nodes.instance_group_urls
  description = "Instance group URLs created with the node pool"
}

output "storage_bucket" {
    description = "name of storage bucket"
    value = google_storage_bucket.tf_state.name
}

output "bq_dataset" {
    description = "ID of bigquery dataset"
    value = google_bigquery_dataset.analytics.dataset_id
}