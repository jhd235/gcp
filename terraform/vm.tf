# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "instance-20250405-163648" {
  boot_disk {
    auto_delete = true
    device_name = "instance-20250405-163648"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250311"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-x86-template-1-4-0"
  }

  machine_type = "e2-micro"

  metadata = {
    enable-osconfig = "TRUE"
  }

  name = "instance-20250405-163648"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/soy-transducer-455914-i5/regions/europe-west10/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "109297754786-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server"]
  zone = "europe-west10-a"
}

module "ops_agent_policy" {
  source        = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project       = "soy-transducer-455914-i5"
  zone          = "europe-west10-a"
  assignment_id = "goog-ops-agent-v2-x86-template-1-4-0-europe-west10-a"
  agents_rule = {
    package_state = "installed"
    version       = "latest"
  }
  instance_filter = {
    all = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-x86-template-1-4-0"
      }
    }]
  }
}
