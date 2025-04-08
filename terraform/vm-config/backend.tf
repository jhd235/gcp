terraform {
  backend "gcs" {
    bucket      = "gcp-doe-iac-state"
    prefix      = "terraform/state"
    credentials = "./soy-transducer-455914-i5-eb4acc5d0af2.json"
  }
} 