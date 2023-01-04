terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.85.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "qwiklabs-gcp-00-616a397f0933"
  region = "asia-south1"
  zone = "asia-south1-a"
}

resource "google_storage_bucket" "my-bckt" {
  
  name = "my-first-tf-bucket"
  storage_class = "NEARLINE"
  location = "US-CENTRAL1"
  uniform_bucket_level_access = true
}
resource "google_storage_bucket_object" "picture" {
  name = "girrafe_pic"
  bucket = google_storage_bucket.my-bckt.name
  source = "girrafe.jpg"
}
