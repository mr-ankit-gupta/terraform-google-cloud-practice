terraform {
	required_providers {
		google = {
			source = "hashicorp/google"
			version = "3.85.0"
		}
	}
}
provider "google"{
	project = "qwiklabs-gcp-02-846bad801698"
	region = "asia-southeast1"
	zone = "asia-southeast1-a"
}

resource "google_pubsub_topic" "my_topic"{
	name = "my-tf-topic"
}

resource "google_pubsub_subscription" "my-sub"{
	name = "my-tf-sub"
	topic = google_pubsub_topic.my_topic.name
}
