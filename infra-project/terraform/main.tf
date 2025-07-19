provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "tf_state" {
  name     = "${var.project_id}-tf-state"
  location = var.region
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_compute_network" "main_vpc" {
  name = "${var.project_id}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main_subnet" {
  name          = "main-subnet"
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.main_vpc.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_container_cluster" "gke" {
  name     = "${var.project_id}-gke-cluster"
  location = var.region

  network    = google_compute_network.main_vpc.id
  subnetwork = google_compute_subnetwork.main_subnet.id

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-pool"
  cluster    = google_container_cluster.gke.name
  location   = var.region
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_bigquery_dataset" "analytics" {
  dataset_id = "${var.project_id}_dataset"
  location   = var.region
}

