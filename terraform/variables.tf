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
  description = "The name of the GCS bucket for Terraform state"
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

variable "force_destroy" {
  description = "Whether to force destroy the GCS bucket"
  type        = bool
  default     = false
}

variable "trigger_name" {
  description = "The name of the Cloud Build trigger"
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