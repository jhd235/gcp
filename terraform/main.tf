# Create GCS bucket for Terraform state
module "gcs" {
  source = "./modules/gcs"

  bucket_name        = var.bucket_name
  location           = var.location
  storage_class      = var.storage_class
  versioning_enabled = var.versioning_enabled
  lifecycle_age      = var.lifecycle_age
  force_destroy      = var.force_destroy
}

# Create Cloud Build pipeline
module "cloudbuild" {
  source = "./modules/cloudbuild"

  trigger_name   = var.trigger_name
  project_id     = var.project_id
  project_number = var.project_number
  github_owner   = var.github_owner
  github_repo    = var.github_repo
  branch_pattern = "^main$"
}

# Store service account key in Secret Manager
module "secret_manager" {
  source = "./modules/secret-manager"

  service_account_key_json = var.google_credentials
} 