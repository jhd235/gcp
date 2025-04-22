variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "my-vm"
}

variable "machine_type" {
  description = "Machine type for the VM instance"
  type        = string
  default     = "e2-small"
}

variable "zone" {
  description = "Zone where the VM instance will be created"
  type        = string
  default     = "europe-west1-b"
}

variable "region" {
  description = "Region where the resources will be created"
  type        = string
  default     = "europe-west1"
}

variable "image" {
  description = "Boot image for the VM instance"
  type        = string
  default     = "ubuntu-minimal-2210-kinetic-amd64-v20230126"
}

variable "ssh_user" {
  description = "SSH user for the VM instance"
  type        = string
  default     = "ansible"
}

variable "ssh_pub_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "ssh_keys/id_rsa.pub"
} 