# This file will contain the main resource configurations
# Add your resource configurations here

# Example: Uncomment and modify the following if you want to manage the storage bucket
# resource "google_storage_bucket" "state_bucket" {
#   name          = "gcp-doe-iac-state"
#   location      = "EU"
#   force_destroy = false
# 
#   versioning {
#     enabled = true
#   }
# 
#   uniform_bucket_level_access = true
# } 