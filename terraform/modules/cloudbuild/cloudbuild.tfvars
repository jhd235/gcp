# Cloud Build Module Configuration
trigger_name        = "my-app-build-trigger"
trigger_description = "Builds and pushes Docker images on main branch changes"
project_id          = "soy-transducer-455914-i5"
project_number      = "455914" # Your project number from GCP
github_owner        = "jhd235" # Your GitHub username
github_repo         = "gcp"    # Your repository name
branch_pattern      = "^main$"
image_name          = "my-app"