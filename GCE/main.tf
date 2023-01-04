terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.85.0"
    }
  }
}

provider "google" {
    project = "qwiklabs-gcp-04-ee56ecc7931f"
    region = "asia-south1"
    zone = "asia-south1-a"
}

resource "google_compute_network" "My_vpc" {
    name = "tryandseevpc"
    auto_create_subnetworks = false
    description = "dont not use this with out info"
    mtu = 1460
}

resource "google_compute_subnetwork" "subnet1-asia-south1"{
    name = "subnetwork-asia-south1"
    region = "asia-south1"
    network = google_compute_network.My_vpc.id
    ip_cidr_range = "192.22.78.0/24"
}

resource "google_compute_firewall" "allow-icmp" {
    name = "allow-custome"
    network = google_compute_network.My_vpc.id
    source_ranges = [ "0.0.0.0/0" ]
    allow {
      protocol = "icmp"
    }
    allow {
      ports = ["22" , "80" , "1000-2000" , "3389"]
      protocol = "tcp"
    }
   

}


resource "google_compute_instance" "my-first-vm" {
    name = "my-first-vm"
    machine_type = "e2-medium"
    
    boot_disk {
      initialize_params {
        image = "ubuntu-1804-bionic-v20221201"
      }
    }
    network_interface {
      network = google_compute_network.My_vpc.id
      subnetwork = google_compute_subnetwork.subnet1-asia-south1.id
      access_config {
     // Include this section to give the VM an external ip address
   }
    }
    service_account {
      email = "496390371571-compute@developer.gserviceaccount.com"
      scopes = ["cloud-platform"]
    }
    metadata_startup_script =<<SCRIPT
      sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
mkdir tf-workspace
cd tf-workspace


      SCRIPT
    }
