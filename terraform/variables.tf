variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
}

variable "location" {
  description = "The location of the GCS bucket"
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "The storage class of the GCS bucket"
  type        = string
  default     = "STANDARD"
}

variable "versioning_enabled" {
  description = "Whether versioning is enabled for the GCS bucket"
  type        = bool
  default     = false
}

variable "lifecycle_age" {
  description = "The number of days to retain files in the GCS bucket"
  type        = number
  default     = 30
}

variable "force_destroy" {
  description = "Whether to force destroy the GCS bucket"
  type        = bool
  default     = false
}

variable "trigger_name" {
  description = "The name of the Cloud Build trigger"
  type        = string
}

variable "project_number" {
  description = "The GCP project number"
  type        = string
}

variable "github_owner" {
  description = "The GitHub owner"
  type        = string
}

variable "github_repo" {
  description = "The GitHub repository"
  type        = string
}

variable "branch_pattern" {
  description = "The branch pattern for the Cloud Build trigger"
  type        = string
  default     = "^main$"
}

variable "google_credentials" {
  description = "The Google Cloud credentials JSON"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "secret_id" {
  description = "The ID of the secret in Secret Manager"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,254}$", var.secret_id))
    error_message = "Secret ID must be 1-255 characters long, start with a letter, and can only contain letters, numbers, hyphens, and underscores."
  }
} 