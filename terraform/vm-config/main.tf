terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "gcp-doe-iac-state"
    prefix = "terraform/vm-state"
  }
}

provider "google" {
  project = var.project_id
  region  = "europe-west10"
  zone    = "europe-west10-a"
}

# Create VM instance
resource "google_compute_instance" "default" {
  name         = "instance-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  machine_type = "e2-micro"
  zone         = "europe-west10-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250311"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = "projects/${var.project_id}/regions/europe-west10/subnetworks/default"
    access_config {
      // Ephemeral public IP
    }
  }

  tags = ["http-server"]

  metadata = {
    enable-osconfig = "TRUE"
  }

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  service_account {
    email = "${var.project_number}-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }
} 