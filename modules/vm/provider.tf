terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.30.0"
    }
  }
}

provider "google" {
  project     = "soy-transducer-455914-i5"
  region      = "europe-west1"
} 