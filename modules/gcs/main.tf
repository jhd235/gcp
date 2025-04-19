resource "google_storage_bucket" "default" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = false

  versioning {
    enabled = false
  }

  uniform_bucket_level_access = true

} 