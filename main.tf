module "gcs" {
  source = "./modules/gcs"

  bucket_name = "gcp-doe-iac-state"
  location    = "EU"
} 