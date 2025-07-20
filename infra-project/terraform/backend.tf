provider "google" {  
}

terraform {
  backend "gcs" {
    bucket     = "optimistic-tree-465716-j8-tf-state"
    prefix     = "terraform/project1/state"
  }
}