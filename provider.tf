terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "soy-transducer-455914-i5"
  region  = "europe-west1"  # Default region, can be overridden in resource configurations
} 