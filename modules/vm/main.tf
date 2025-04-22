/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# [START compute_basic_vm_parent_tag]
# [START compute_instances_create]

# Create a VM instance from a public image
# in the `default` VPC network and subnet

resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys                     = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
    ansible_user                 = var.ssh_user
    ansible_ssh_private_key_file = replace(var.ssh_pub_key_path, ".pub", "")
    ansible_python_interpreter   = "/usr/bin/python3"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip python3-dev
    pip3 install --upgrade pip
    # Install common Ansible dependencies
    apt-get install -y software-properties-common openssh-server
    # Ensure Python is available at /usr/bin/python
    ln -sf /usr/bin/python3 /usr/bin/python
    # Configure SSH
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
  EOF

  tags = ["allow-ssh"]
}

# Create firewall rule to allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

# [START vpc_compute_basic_vm_custom_vpc_network]
resource "google_compute_network" "custom" {
  name                    = "my-network"
  auto_create_subnetworks = false
}
# [END vpc_compute_basic_vm_custom_vpc_network]

# [START vpc_compute_basic_vm_custom_vpc_subnet]
resource "google_compute_subnetwork" "custom" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.custom.id
}
# [END vpc_compute_basic_vm_custom_vpc_subnet]

# [START compute_instances_create_with_subnet]

# Create a VM in a custom VPC network and subnet

resource "google_compute_instance" "custom_subnet" {
  name         = "${var.instance_name}-custom"
  tags         = ["allow-ssh"]
  zone         = var.zone
  machine_type = var.machine_type

  network_interface {
    network    = google_compute_network.custom.id
    subnetwork = google_compute_subnetwork.custom.id
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  metadata = {
    ssh-keys                     = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
    ansible_user                 = var.ssh_user
    ansible_ssh_private_key_file = replace(var.ssh_pub_key_path, ".pub", "")
    ansible_python_interpreter   = "/usr/bin/python3"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip python3-dev
    pip3 install --upgrade pip
    # Install common Ansible dependencies
    apt-get install -y software-properties-common openssh-server
    # Ensure Python is available at /usr/bin/python
    ln -sf /usr/bin/python3 /usr/bin/python
    # Configure SSH
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
  EOF
}
# [END compute_instances_create_with_subnet]
# [END compute_basic_vm_parent_tag]

