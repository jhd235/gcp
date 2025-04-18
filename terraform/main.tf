# Main Terraform configuration file
# This file orchestrates the creation of GCP infrastructure components

# Provider configuration is managed in provider.tf
# Variable definitions are in variables.tf
# Backend configuration is in backend.tf

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Create GCS bucket for Terraform state
resource "google_storage_bucket" "state" {
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  versioning {
    enabled = true
  }
}

# Create Cloud Build trigger
resource "google_cloudbuild_trigger" "pipeline" {
  name        = var.trigger_name
  description = "Terraform pipeline trigger"
  project     = var.project_id

  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = var.branch_pattern
    }
  }

  filename = "cloudbuild.yaml"
}

# Store service account key in Secret Manager
resource "google_secret_manager_secret" "service_account_key" {
  secret_id = "terraform-service-account-key"
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "service_account_key" {
  secret      = google_secret_manager_secret.service_account_key.id
  secret_data = var.google_credentials
} 