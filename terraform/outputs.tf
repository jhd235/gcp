# Outputs for GCS module
output "bucket_name" {
  description = "The name of the created GCS bucket"
  value       = module.gcs.bucket_name
}

output "bucket_url" {
  description = "The URL of the created GCS bucket"
  value       = module.gcs.bucket_url
}

# Outputs for Cloud Build module
output "cloudbuild_trigger_id" {
  description = "The ID of the created Cloud Build trigger"
  value       = module.cloudbuild.trigger_id
}

output "cloudbuild_trigger_name" {
  description = "The name of the created Cloud Build trigger"
  value       = module.cloudbuild.trigger_name
}

# Outputs for Secret Manager module
output "secret_manager_secret_id" {
  description = "The ID of the created Secret Manager secret"
  value       = module.secret_manager.secret_id
}

output "secret_manager_secret_version" {
  description = "The version of the created secret in Secret Manager"
  value       = module.secret_manager.secret_version
  sensitive   = true
}

# Combined outputs
output "environment" {
  description = "The environment this infrastructure is deployed to"
  value       = var.environment
}

output "project_id" {
  description = "The GCP project ID"
  value       = var.project_id
} 