# Root level variables can be added here if needed 

# Cloud Build Configuration
project_id     = "your-project-id"
project_number = "your-project-number"
github_owner   = "your-github-username"
github_repo    = "your-repo-name"
trigger_name   = "terraform-pipeline"

# GCS Configuration (if needed)
bucket_name        = "your-project-id-terraform-state"
location           = "US"
storage_class      = "STANDARD"
versioning_enabled = false
lifecycle_age      = 30
force_destroy      = false

# Additional variables
region            = "us-central1"
branch_pattern    = "^main$" 