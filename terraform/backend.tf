terraform {
  backend "gcs" {
    bucket      = "gcp-doe-iac-state"
    prefix      = "terraform/state"
    lock_timeout = "5m"
  }
} 