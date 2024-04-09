terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.60"
    }
  }
}

provider "google" {
  project     = "philipace"
  region      = "europe-west2"
  credentials = "philipace_key.json"
}