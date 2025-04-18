variable "bucket_name" {
  description = "The name of the GCS bucket (must be globally unique)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters long, can only contain lowercase letters, numbers, dots, hyphens, and underscores, and must start and end with a letter or number."
  }
}

variable "location" {
  description = "The location of the GCS bucket"
  type        = string
  default     = "US"
  validation {
    condition     = contains(["US", "EU", "ASIA", "us-central1", "us-east1", "us-west1", "europe-west1", "asia-east1"], var.location)
    error_message = "Location must be a valid GCP region or multi-region."
  }
}

variable "storage_class" {
  description = "The storage class of the GCS bucket"
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "versioning_enabled" {
  description = "Whether to enable versioning on the GCS bucket"
  type        = bool
  default     = false
}

variable "lifecycle_age" {
  description = "Number of days to retain files in the bucket"
  type        = number
  default     = 30
  validation {
    condition     = var.lifecycle_age >= 0
    error_message = "Lifecycle age must be a non-negative number."
  }
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "google_credentials" {
  description = "The Google Cloud credentials JSON"
  type        = string
  sensitive   = true
  validation {
    condition     = can(jsondecode(var.google_credentials))
    error_message = "Google credentials must be valid JSON."
  }
}

variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

# Cloud Build Variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6 to 30 characters long, can only contain lowercase letters, numbers, and hyphens, and must start with a letter."
  }
}

variable "project_number" {
  description = "The GCP project number"
  type        = string
  validation {
    condition     = can(regex("^[0-9]{12}$", var.project_number))
    error_message = "Project number must be a 12-digit number."
  }
}

variable "github_owner" {
  description = "The GitHub repository owner"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*$", var.github_owner))
    error_message = "GitHub owner must be a valid GitHub username."
  }
}

variable "github_repo" {
  description = "The GitHub repository name"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*$", var.github_repo))
    error_message = "GitHub repository name must be a valid repository name."
  }
}

variable "trigger_name" {
  description = "The name of the Cloud Build trigger"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,99}$", var.trigger_name))
    error_message = "Trigger name must be 1-100 characters long, start with a letter, and can only contain letters, numbers, and hyphens."
  }
}

variable "branch_pattern" {
  description = "The branch pattern for the Cloud Build trigger"
  type        = string
  default     = "^main$"
  validation {
    condition     = can(regex("^\\^[a-zA-Z0-9-_/]+\\$$", var.branch_pattern))
    error_message = "Branch pattern must be a valid regex pattern for branch names."
  }
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "secret_id" {
  description = "The ID of the secret in Secret Manager"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,254}$", var.secret_id))
    error_message = "Secret ID must be 1-255 characters long, start with a letter, and can only contain letters, numbers, hyphens, and underscores."
  }
} 