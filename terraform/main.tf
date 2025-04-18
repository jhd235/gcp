# Main Terraform configuration file
# This file orchestrates the creation of GCP infrastructure components

# Provider configuration is managed in provider.tf
# Variable definitions are in variables.tf
# Backend configuration is in backend.tf

# Create GCS bucket for Terraform state and general storage
module "gcs" {
  source = "./modules/gcs"

  bucket_name        = var.bucket_name
  location           = var.location
  storage_class      = var.storage_class
  versioning_enabled = var.versioning_enabled
  lifecycle_age      = var.lifecycle_age
  force_destroy      = var.force_destroy

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_id
  }
}

# Create Cloud Build pipeline for CI/CD
module "cloudbuild" {
  source = "./modules/cloudbuild"

  trigger_name   = var.trigger_name
  project_id     = var.project_id
  project_number = var.project_number
  github_owner   = var.github_owner
  github_repo    = var.github_repo
  branch_pattern = var.branch_pattern

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_id
  }
}

# Store service account key in Secret Manager securely
module "secret_manager" {
  source = "./modules/secret-manager"

  service_account_key_json = var.google_credentials
  secret_id               = var.secret_id
  project_id             = var.project_id

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_id
  }
}

# Output important information
output "gcs_bucket_name" {
  description = "The name of the created GCS bucket"
  value       = module.gcs.bucket_name
}

output "cloudbuild_trigger_id" {
  description = "The ID of the created Cloud Build trigger"
  value       = module.cloudbuild.trigger_id
}

output "secret_manager_secret_id" {
  description = "The ID of the created secret in Secret Manager"
  value       = module.secret_manager.secret_id
  sensitive   = true
} 